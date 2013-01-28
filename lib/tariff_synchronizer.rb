# NOTE sequel-rails initializes too late, fasten it up.
Sequel::Rails.configuration.init_database(Rails.configuration.database_configuration)
Sequel::Rails.connect(Rails.env)

require 'tariff_importer'
require 'date'
require 'logger'
require 'fileutils'
require 'active_support/notifications'
require 'active_support/log_subscriber'

require 'tariff_synchronizer/logger'

# How TariffSynchronizer works
#
# Download
#
# Try downloading all updates up until today & try redownload failed updates(?)
#   If any errors occur while downloading retry until retry_count is reached and then mark as failed.
#
# Apply
#
# Updates marked as failed present
#   Log error, send error email
# No updates marked as failed
#   Try applying updates
#   Errors occured while applying
#     Log error, send email
#     Revert everything back
#     Mark update as failed
#   No errors occured while applying
#     Log info message?
#     Send success email?

module TariffSynchronizer
  autoload :Mailer,        'tariff_synchronizer/mailer'
  autoload :PendingUpdate, 'tariff_synchronizer/pending_update'
  autoload :TaricUpdate,   'tariff_synchronizer/taric_update'
  autoload :ChiefUpdate,   'tariff_synchronizer/chief_update'
  autoload :TaricArchive,  "tariff_synchronizer/taric_archive"
  autoload :ChiefArchive,  "tariff_synchronizer/chief_archive"

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

  # Download pending updates for Taric and National data
  # Gets latest downloaded file present in (inbox/failbox/processed) and tries
  # to download any further updates to current day.
  def download
    if sync_variables_set?
      ActiveSupport::Notifications.instrument("download.tariff_synchronizer") do
        [TaricUpdate, ChiefUpdate].map(&:sync)
      end
    else
      ActiveSupport::Notifications.instrument("config_error.tariff_synchronizer")
    end
  end

  def download_archive
    if sync_variables_set?
      ActiveSupport::Notifications.instrument("download.tariff_synchronizer") do
        [TaricArchive, ChiefArchive].map(&:sync)
      end
    else
      ActiveSupport::Notifications.instrument("config_error.tariff_synchronizer")
    end
  end

  # Applies all updates (from inbox/failbox) by their date starting from the
  # oldest one.
  def apply
    if BaseUpdate.failed.any?
      file_names = BaseUpdate.failed.map(&:filename)

      ActiveSupport::Notifications.instrument("failed_updates_present.tariff_synchronizer", file_names: file_names)
    else
      pending_update_count = PendingUpdate.count

      PendingUpdate.all
                   .sort_by(&:issue_date)
                   .sort_by(&:update_priority)
                   .each do |pending_update|
        Sequel::Model.db.transaction do
          begin
            pending_update.apply

            ::ChiefTransformer.instance.invoke(:update) if pending_update.update_type == "TariffSynchronizer::ChiefUpdate"
          rescue TaricImporter::ImportException,
                 ChiefImporter::ImportException,
                 TariffImporter::NotFound  => exception
            ActiveSupport::Notifications.instrument("failed_update.tariff_synchronizer", exception: exception,
                                                                                         update: pending_update)

            raise Sequel::Rollback
          end
        end
      end

      ActiveSupport::Notifications.instrument("apply.tariff_synchronizer", count: pending_update_count) if BaseUpdate.pending_or_failed.none?
    end
  end

  # Builds tariff_update entries from files available in the
  # TariffSynchronizer.root_path directories.
  #
  # Warning: rebuilt updates will be marked as pending.
  # missing or failed updates are not restored.
  def rebuild
    ActiveSupport::Notifications.instrument("rebuild.tariff_synchronizer") do
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
end
