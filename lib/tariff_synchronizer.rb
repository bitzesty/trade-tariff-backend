require 'date'
require 'logger'
require 'fileutils'
require 'redis_lock'
require 'active_support/notifications'
require 'active_support/log_subscriber'

require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/base_update_importer'
require 'tariff_synchronizer/chief_file_name_generator'
require 'tariff_synchronizer/file_service'
require 'tariff_synchronizer/logger'
require 'tariff_synchronizer/taric_file_name_generator'
require 'tariff_synchronizer/taric_update_downloader'
require 'tariff_synchronizer/tariff_downloader'

# How TariffSynchronizer works
#
# See https://github.com/alphagov/trade-tariff-backend/wiki/Synchronization-process
#

module TariffSynchronizer

  class FailedUpdatesError < StandardError; end

  autoload :ChiefUpdate,   'tariff_synchronizer/chief_update'
  autoload :Mailer,        'tariff_synchronizer/mailer'
  autoload :TaricUpdate,   'tariff_synchronizer/taric_update'

  extend self

  mattr_accessor :username
  self.username = ENV["TARIFF_SYNC_USERNAME"]

  mattr_accessor :password
  self.password = ENV["TARIFF_SYNC_PASSWORD"]

  mattr_accessor :host
  self.host = ENV["TARIFF_SYNC_HOST"]

  mattr_accessor :root_path
  self.root_path = "data"

  # Numer of seconds to sleep between sync retries
  mattr_accessor :request_throttle
  self.request_throttle = 60

  # Initial dump date + 1 day
  mattr_accessor :taric_initial_update_date
  self.taric_initial_update_date = Date.new(2012,6,6)

  # Initial dump date + 1 day
  mattr_accessor :chief_initial_update_date
  self.chief_initial_update_date = Date.new(2012,6,30)

  # Times to retry downloading update before giving up
  mattr_accessor :retry_count
  self.retry_count = 20

  # Times to retry downloading update in case of serious problems (host resolution, ssl handshake, partial file) before giving up
  mattr_accessor :exception_retry_count
  self.exception_retry_count = 10

  # CHIEF update url template
  mattr_accessor :chief_update_url_template
  self.chief_update_url_template = "%{host}/taric/%{file_name}"

  # TARIC query url template
  mattr_accessor :taric_query_url_template
  self.taric_query_url_template = "%{host}/taric/TARIC3%{date}"

  # TARIC update url template
  mattr_accessor :taric_update_url_template
  self.taric_update_url_template = "%{host}/taric/%{filename}"

  # Number of days to warn about missing updates after
  mattr_accessor :warning_day_count
  self.warning_day_count = 4

  delegate :instrument, :subscribe, to: ActiveSupport::Notifications

  # Download pending updates for TARIC and CHIEF data
  # Gets latest downloaded file present in (inbox/failbox/processed) and tries
  # to download any further updates to current day.
  def download
    return instrument("config_error.tariff_synchronizer") unless sync_variables_set?

    TradeTariffBackend.with_redis_lock do
      instrument("download.tariff_synchronizer") do
        begin
          [TaricUpdate, ChiefUpdate].map(&:sync)
        rescue TariffUpdatesRequester::DownloadException => exception
          instrument("failed_download.tariff_synchronizer", exception: exception)
          raise exception.original
        end
      end
    end
  end

  def apply
    check_tariff_updates_failures

    applied_updates = []
    unconformant_records = []

    # The sync task is run on multiple machines to avoid more than on process
    # running the apply task it is wrapped with a redis lock
    TradeTariffBackend.with_redis_lock do

      # Updates could be modifying primary keys so unrestricted it for all models.
      Sequel::Model.subclasses.each(&:unrestrict_primary_key)

      subscribe /conformance_error/ do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        unconformant_records << event.payload[:record]
      end

      date_range_since_last_pending_update.each do |day|
        # TARIC updates should be applied before CHIEF
        applied_updates << perform_update(TaricUpdate, day)
        applied_updates << perform_update(ChiefUpdate, day)
      end

      applied_updates.flatten!

      instrument("apply.tariff_synchronizer",
        update_names: applied_updates.map(&:filename),
        unconformant_records: unconformant_records
      ) if applied_updates.any? && BaseUpdate.pending_or_failed.none?
    end

    rescue RedisLock::LockTimeout
      instrument "apply_lock_error.tariff_synchronizer"
  end

  # Restore database to specific date in the past
  #
  # NOTE: this does not remove records from initial seed
  def rollback(rollback_date, keep = false)
    TradeTariffBackend.with_redis_lock do
      date = Date.parse(rollback_date.to_s)

      (date..Date.current).to_a.reverse.each do |date_for_rollback|
        Sequel::Model.db.transaction do
          oplog_based_models.each do |model|
            model.operation_klass.where { operation_date > date_for_rollback }.delete
          end

          if keep
            TariffSynchronizer::TaricUpdate.applied_or_failed.where { issue_date > date_for_rollback }.each do |taric_update|
              taric_update.mark_as_pending
              taric_update.clear_applied_at
            end
            TariffSynchronizer::ChiefUpdate.applied_or_failed.where { issue_date > date_for_rollback }.each do |chief_update|
              [Chief::Comm, Chief::Mfcm, Chief::Tame, Chief::Tamf, Chief::Tbl9].each do |chief_model|
                chief_model.where(origin: chief_update.filename).delete
              end

              chief_update.mark_as_pending
              chief_update.clear_applied_at
            end
          else
            TariffSynchronizer::TaricUpdate.where { issue_date > date }.delete
            TariffSynchronizer::ChiefUpdate.where { issue_date > date }.each do |chief_update|
              [Chief::Comm, Chief::Mfcm, Chief::Tame, Chief::Tamf, Chief::Tbl9].each do |chief_model|
                chief_model.where(origin: chief_update.filename).delete
              end

              chief_update.delete
            end
          end
        end
      end

      instrument(
        "rollback.tariff_synchronizer",
        date: date,
        keep: keep
      )
    end
  rescue RedisLock::LockTimeout
    instrument(
      "rollback_lock_error.tariff_synchronizer",
      date: rollback_date,
      keep: keep
    )
  end

  def initial_update_date_for(update_type)
    send("#{update_type}_initial_update_date")
  end

  private

  def perform_update(update_type, day)
    updates = update_type.pending_at(day).to_a
    updates.map{ |update| BaseUpdateImporter.perform(update) }
    updates
  end

  def date_range_since_last_pending_update
    last_pending_update = BaseUpdate.last_pending
    return [] if last_pending_update.blank?
    (last_pending_update.issue_date..update_to)
  end

  def update_to
    ENV['DATE'] ? Date.parse(ENV['DATE']) : Date.current
  end

  def sync_variables_set?
    username.present? && password.present? && host.present?
  end

  def oplog_based_models
    Sequel::Model.subclasses.select { |model|
      model.plugins.include?(Sequel::Plugins::Oplog)
    }
  end

  def check_tariff_updates_failures
    if BaseUpdate.failed.any?
      instrument("failed_updates_present.tariff_synchronizer",
                 file_names: BaseUpdate.failed.map(&:filename))
      raise FailedUpdatesError
    end
  end
end
