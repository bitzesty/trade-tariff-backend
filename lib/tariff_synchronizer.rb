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
  self.username = ENV['SYNC_USERNAME']

  mattr_accessor :password
  self.password = ENV['SYNC_PASSWORD']

  mattr_accessor :host
  self.host = ENV['SYNC_HOST']

  mattr_accessor :admin_email
  self.admin_email = ENV['SYNC_EMAIL']

  mattr_accessor :logger
  self.logger = Logger.new('log/sync.log')

  mattr_accessor :root_path
  self.root_path = Rails.env.test? ? "tmp/data" : "data"

  mattr_accessor :inbox_path
  self.inbox_path = Rails.env.test? ? "tmp/data/inbox" : "data/inbox"

  mattr_accessor :failbox_path
  self.failbox_path = Rails.env.test? ? "tmp/data/failbox" : "data/failbox"

  mattr_accessor :processed_path
  self.processed_path = Rails.env.test? ? "tmp/data/processed" : "data/processed"

  mattr_accessor :request_throttle
  self.request_throttle = 1

  # Initial dump date
  mattr_accessor :taric_initial_update
  self.taric_initial_update = Date.new(2012,6,5)

  # Initial dump date
  mattr_accessor :chief_initial_update
  self.chief_initial_update = Date.new(2012,6,5)

  # Download pending updates for Taric and National data
  # Gets latest downloaded file present in (inbox/failbox/processed) and tries
  # to download any further updates to current day.
  def download
    logger.info "Starting sync at: #{Time.now}"

    [TaricUpdate, ChiefUpdate].map(&:sync)
  end

  # Applies all updates (from inbox/failbox) by their date starting from the
  # oldest one.
  def apply
    logger.info "Starting update application at: #{Time.now}"

    PendingUpdate.all
                 .sort_by(&:date)
                 .sort_by(&:update_priority)
                 .each do |pending_update|
      Sequel::Model.db.transaction do
        begin
          pending_update.apply
        rescue TariffImporter::TaricImportException,
               TariffImporter::ChiefImportException,
               TariffImporter::ChiefTransformException => exception
          logger.error "Update failed: #{pending_update}"
          pending_update.move_to(:failbox)

          notify_admin(pending_update.file_name, exception)

          raise Sequel::Rollback
        end
      end
    end
  end

  # Initial update day for specific update type
  def initial_update_for(update_type)
    send("#{update_type}_initial_update".to_sym)
  end

  private

  def notify_admin(failed_file_path, exception)
    SyncMailer.admin_notification(admin_email, failed_file_path, exception).deliver
  end
end
