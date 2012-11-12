# NOTE sequel-rails initializes too late, fasten it up.
Sequel::Rails.configuration.init_database(Rails.configuration.database_configuration)
Sequel::Rails.connect(Rails.env)

require 'tariff_importer'
require 'date'
require 'logger'
require 'fileutils'
require 'active_support/notifications'
require 'active_support/log_subscriber'
require 'tariff_synchronizer/pending_update'
require 'tariff_synchronizer/chief_update'
require 'tariff_synchronizer/taric_update'
require 'tariff_synchronizer/logger'

# How TariffSynchronizer works

module TariffSynchronizer
  extend self

  mattr_accessor :username
  self.username = TradeTariffBackend.secrets.sync_username

  mattr_accessor :password
  self.password = TradeTariffBackend.secrets.sync_password

  mattr_accessor :host
  self.host = TradeTariffBackend.secrets.sync_host

  mattr_accessor :admin_email
  self.admin_email = TradeTariffBackend.secrets.sync_email

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

  # Applies all updates (from inbox/failbox) by their date starting from the
  # oldest one.
  def apply
    if BaseUpdate.failed.any?
      file_names = BaseUpdate.failed.map(&:filename)

      ActiveSupport::Notifications.instrument("failed_updates_present.tariff_synchronizer", file_names: file_names)
    else
      ActiveSupport::Notifications.instrument("apply.tariff_synchronizer") do
        PendingUpdate.all
                     .sort_by(&:issue_date)
                     .sort_by(&:update_priority)
                     .each do |pending_update|
          Sequel::Model.db.transaction do
            begin
              pending_update.apply
            rescue TaricImporter::ImportException,
                   ChiefImporter::ImportException  => exception
              ActiveSupport::Notifications.instrument("failed_update.tariff_synchronizer", update: pending_update)

              notify_admin(pending_update.file_name, exception)

              raise Sequel::Rollback
            end
          end
        end
      end
    end
  end

  # Builds tariff_update entries from files available in the
  # TariffSynchronizer.root_path directories.
  #
  # Warning: rebuilt updates will be marked as pending.
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
    self.username.present? && self.password.present? && self.host.present? && self.admin_email.present?
  end

  def notify_admin(failed_file_path, exception)
    SyncMailer.admin_notification(admin_email, failed_file_path, exception).deliver
  end
end
