require 'tariff_importer'
require 'date'
require 'logger'
require 'fileutils'
require 'active_support/notifications'
require 'active_support/log_subscriber'

require 'tariff_synchronizer/logger'

# How TariffSynchronizer works
#
# See https://github.com/alphagov/trade-tariff-backend/wiki/Synchronization-process
#

module TariffSynchronizer
  autoload :ChiefArchive,  'tariff_synchronizer/chief_archive'
  autoload :ChiefUpdate,   'tariff_synchronizer/chief_update'
  autoload :Mailer,        'tariff_synchronizer/mailer'
  autoload :PendingUpdate, 'tariff_synchronizer/pending_update'
  autoload :TaricArchive,  'tariff_synchronizer/taric_archive'
  autoload :TaricUpdate,   'tariff_synchronizer/taric_update'

  extend self

  mattr_accessor :username
  self.username = TradeTariffBackend.secrets.sync_username

  mattr_accessor :password
  self.password = TradeTariffBackend.secrets.sync_password

  mattr_accessor :host
  self.host = TradeTariffBackend.secrets.sync_host

  mattr_accessor :root_path
  self.root_path = Rails.env.test? ? "tmp/data" : "data"

  mattr_accessor :request_throttle
  self.request_throttle = 1

  # Initial dump date + 1 day
  mattr_accessor :taric_initial_update
  self.taric_initial_update = Date.new(2012,6,6)

  # Initial dump date + 1 day
  mattr_accessor :chief_initial_update
  self.chief_initial_update = Date.new(2012,6,30)

  # Times to retry downloading update before giving up
  mattr_accessor :retry_count
  self.retry_count = 10

  # CHIEF update url template
  mattr_accessor :chief_update_url_template
  self.chief_update_url_template = "%{host}/taric/%{file_name}"

  # Taric query url template
  mattr_accessor :taric_query_url_template
  self.taric_query_url_template = "%{host}/taric/TARIC3%{date}"

  # Taric update url template
  mattr_accessor :taric_update_url_template
  self.taric_update_url_template = "%{host}/taric/%{file_name}"

  # Number of days to warn about missing updates after
  mattr_accessor :warning_day_count
  self.warning_day_count = 3

  delegate :instrument, :subscribe, to: ActiveSupport::Notifications

  # Download pending updates for Taric and National data
  # Gets latest downloaded file present in (inbox/failbox/processed) and tries
  # to download any further updates to current day.
  def download
    if sync_variables_set?
      instrument("download.tariff_synchronizer") do
        begin
          [TaricUpdate, ChiefUpdate].map(&:sync)
        rescue FileService::DownloadException => exception
          instrument("failed_download.tariff_synchronizer", exception: exception.original,
                                                                                         url: exception.url)

          raise exception.original
        end
      end
    else
      instrument("config_error.tariff_synchronizer")
    end
  end

  def download_archive
    if sync_variables_set?
      instrument("download.tariff_synchronizer") do
        [TaricArchive, ChiefArchive].map(&:sync)
      end
    else
      instrument("config_error.tariff_synchronizer")
    end
  end

  # Applies all updates (from inbox/failbox) by their date starting from the
  # oldest one.
  def apply
    # We will be fetching updates from Taric and modifying primary keys
    # so unrestrict it for all models.
    Sequel::Model.descendants.each(&:unrestrict_primary_key)

    if BaseUpdate.failed.any?
      file_names = BaseUpdate.failed.map(&:filename)

      instrument(
        "failed_updates_present.tariff_synchronizer",
        file_names: file_names
      )
    else
      unconformant_records = []

      subscribe /conformance_error/ do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        unconformant_records << event.payload[:record]
      end

      PendingUpdate.all.tap do |pending_updates|
        pending_updates.sort_by(&:file_name)
                       .sort_by(&:update_priority)
                       .each do |pending_update|
          Sequel::Model.db.transaction do
            begin
              pending_update.apply

              ::ChiefTransformer.instance.invoke(:update) if pending_update.update_type == "TariffSynchronizer::ChiefUpdate"
            rescue TaricImporter::ImportException,
                   ChiefImporter::ImportException,
                   TariffImporter::NotFound => exception
              instrument(
                "failed_update.tariff_synchronizer",
                exception: exception,
                update: pending_update
              )

              pending_update.mark_as_failed

              # re-raise to end application process here
              # Sequel transaction gets rolled back too
              raise exception
            end
          end
        end

        if pending_updates.any? && BaseUpdate.pending_or_failed.none?
          instrument(
            "apply.tariff_synchronizer",
            update_names: pending_updates.map(&:file_name),
            count: pending_updates.size,
            unconformant_records: unconformant_records
          )
        end
      end
    end
  end

  # Restore database to specific date in the past
  # Usually you will want to run apply operation after rolling back
  #
  # NOTE: this does not remove records from initial seed
  def rollback(date, redownload = false)
    Sequel::Model.db.transaction do
      # Delete all entries in oplog tables with operation > DATE
      oplog_based_models.each do |model|
        model.operation_klass.where { operation_date > date }.delete
      end

      if redownload
        # Delete all Tariff updates if issue_date > DATE (includes missing)
        TariffSynchronizer::TaricUpdate.where { issue_date > date }.delete
        TariffSynchronizer::ChiefUpdate.where { issue_date > date }.each do |chief_update|
          # Remove CHIEF records for specific update
          [Chief::Comm, Chief::Mfcm, Chief::Tame, Chief::Tamf, Chief::Tbl9].each do |chief_model|
            chief_model.where(origin: chief_update.filename).delete
          end

          chief_update.delete
        end
      else
        # Set all applied Tariff updates to pending if issue_date > DATE
        TariffSynchronizer::TaricUpdate.applied.where { issue_date > date }.each(&:mark_as_pending)
        TariffSynchronizer::ChiefUpdate.applied.where { issue_date > date }.each do |chief_update|
          # Remove CHIEF records for specific update
          [Chief::Comm, Chief::Mfcm, Chief::Tame, Chief::Tamf, Chief::Tbl9].each do |chief_model|
            chief_model.where(origin: chief_update.filename).delete
          end

          chief_update.mark_as_pending
        end
      end
    end

    instrument(
      "rollback.tariff_synchronizer",
      date: date,
      redownload: redownload
    )
  end

  # Builds tariff_update entries from files available in the
  # TariffSynchronizer.root_path directories.
  #
  # Warning: rebuilt updates will be marked as pending.
  # missing or failed updates are not restored.
  def rebuild
    instrument("rebuild.tariff_synchronizer") do
      [TaricUpdate, ChiefUpdate].map(&:rebuild)
    end
  end

  # Initial update day for specific update type
  def initial_update_for(update_type)
    send("#{update_type}_initial_update".to_sym)
  end

  private

  def sync_variables_set?
    username.present? &&
    password.present? &&
    host.present? &&
    TradeTariffBackend.admin_email.present?
  end

  def oplog_based_models
    Sequel::Model.descendants.select { |model|
      model.plugins.include?(Sequel::Plugins::Oplog)
    }
  end
end
