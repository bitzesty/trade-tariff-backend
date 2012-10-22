# NOTE sequel-rails initializes too late, fasten it up.
Sequel::Rails.configuration.init_database(Rails.configuration.database_configuration)
Sequel::Rails.connect(Rails.env)

require 'tariff_importer'
require 'date'
require 'logger'
require 'tariff_synchronizer/pending_update'
require 'tariff_synchronizer/chief_update'
require 'tariff_synchronizer/taric_update'
require 'fileutils'

# How TariffSynchronizer works
#
# Basic workflow:
#
# Sync
# ====
# Download all pending updates that are either older than files present in data directory (inbox/failbox/processed)
# for all update types (Taric/CHIEF)
#
# Apply
# =====
# Get oldest date in source directories.
# If files exist for both EU and National
#   If dates are the same for both EU and National file
#       Run import of EU file
#       Run import of National file
#   Else
#       If National file is oldest
#           Run National file if it is (a Saturday or Sunday) or (Monday - Friday whith no EU file produced)
#       Else
#           Run EU file if it is a date whith no National file produced
#       Endif
#   Endif
# Else
#   If only National file exists
#       Run National file if it is (a Saturday or Sunday) or (Monday - Friday whith no EU file produced)
#   Else
#       Run EU file if it is a date whith no National file produced
#   Endif
# Endif

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

  mattr_accessor :logger
  self.logger = Logger.new('log/sync.log')
  self.logger.formatter = Proc.new {|severity, time, progname, msg| "#{time.strftime('%Y-%m-%dT%H:%M:%S.%L %z')} #{sprintf('%5s', severity)} #{msg}" }

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

  # Download pending updates for Taric and National data
  # Gets latest downloaded file present in (inbox/failbox/processed) and tries
  # to download any further updates to current day.
  def download
    if sync_variables_set?
      logger.info "Starting sync at: #{Time.now}"

      [TaricUpdate, ChiefUpdate].map(&:sync)
    else
      logger.error "You need to create: config/trade_tariff_backend_secrets.yml file and set sync variables: username, password, host and email."
    end
  end

  # Applies all updates (from inbox/failbox) by their date starting from the
  # oldest one.
  def apply
    logger.info "Starting update application at: #{Time.now}"

    PendingUpdate.all
                 .sort_by(&:issue_date)
                 .sort_by(&:update_priority)
                 .each do |pending_update|
      Sequel::Model.db.transaction do
        begin
          pending_update.apply
        rescue TaricImporter::ImportException,
               ChiefImporter::ImportException  => exception
          logger.error "Update failed: #{pending_update}"

          notify_admin(pending_update.file_name, exception)

          raise Sequel::Rollback
        end
      end
    end
  end

  # Builds tariff_update entries from files available in the
  # TariffSynchronizer.root_path directories.
  #
  # Warning: rebuilt updates will be marked as pending.
  def rebuild
    [TaricUpdate, ChiefUpdate].map(&:rebuild)
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
