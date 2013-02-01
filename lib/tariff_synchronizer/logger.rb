module TariffSynchronizer
  class Logger < ActiveSupport::LogSubscriber
    cattr_accessor :logger
    self.logger = ::Logger.new('log/tariff_synchronizer.log')
    self.logger.formatter = Proc.new {|severity, time, progname, msg| "#{time.strftime('%Y-%m-%dT%H:%M:%S.%L %z')} #{sprintf('%5s', severity)} #{msg}\n" }

    # Download all pending Taric and Chief updates
    def download(event)
      info "Finished downloading updates"
    end

    # Sync variables were not set correctly
    def config_error(event)
      error "Missing: config/trade_tariff_backend_secrets.yml. Variables: username, password, host and email."
    end

    # There are failed updates (can't proceed)
    def failed_updates_present(event)
      error "TariffSynchronizer found failed updates that need to be fixed before running: #{event.payload[:file_names]}"

      Mailer.failures_reminder(event.payload[:file_names]).deliver
    end

    # Apply all pending Taric and Chief updates
    def apply(event)
      info "Finished applying updates"

      Mailer.applied(event.payload[:update_names],
                     event.payload[:count]).deliver
    end

    # Update failed to be applied
    def failed_update(event)
      error "Update failed: #{event.payload[:update]}"

      Mailer.exception(event.payload[:exception], event.payload[:update])
            .deliver
    end

    # Update download failed
    def failed_download(event)
      error "Download failed: #{event.payload[:exception].to_s}, url: #{event.payload[:url]}"

      Mailer.failed_download(event.payload[:exception], event.payload[:url])
            .deliver
    end

    # Update rebuild from files present in the file system
    def rebuild(event)
      info "Rebuilding updates from file system"
    end

    # Exceeded retry count
    def retry_exceeded(event)
      warn "Download retry count exceeded for #{event.payload[:url]}"

      Mailer.retry_exceeded(event.payload[:url], event.payload[:date]).deliver
    end

    # Update not found
    def not_found(event)
      warn "Update not found for #{event.payload[:date]} at #{event.payload[:url]}"
    end

    # Update not found on file system
    def not_found_on_file_system(event)
      error "Update not found on file system at #{event.payload[:path]}"

      Mailer.file_not_found_on_filesystem(event.payload[:path]).deliver
    end

    # Download chief update
    def download_chief(event)
      info "Downloaded CHIEF update for #{event.payload[:date]}"
    end

    # Apply CHIEF update
    def apply_chief(event)
      info "Applied CHIEF update #{event.payload[:filename]}"
    end

    # Download TARIC update
    def download_taric(event)
      info "Downloaded TARIC update for #{event.payload[:date]} at #{event.payload[:url]}"
    end

    # Apply TARIC update
    def apply_taric(event)
      info "Applied TARIC update #{event.payload[:filename]}"
    end

    # Query for TARIC update path
    def get_taric_update_name(event)
      info "Checking for TARIC update for #{event.payload[:date]} at #{event.payload[:url]}"
    end

    # Update file written to file system
    def update_written(event)
      info "Update file written to file system: #{File.join(Rails.root, event.payload[:path])} (size: #{event.payload[:size]})"
    end

    # Update with blank content received
    def blank_update(event)
      error "Blank update content received for #{event.payload[:date]}: #{event.payload[:url]}"

      Mailer.blank_update(event.payload[:url], event.payload[:url]).deliver
    end

    # Can't open file for writing
    def cant_open_file(event)
      error "Can't open file for writing update at #{event.payload[:path]}"

      Mailer.file_write_error(event.payload[:path], "can't open for writing").deliver
    end

    # Can't write to file
    def cant_write_to_file(event)
      error "Can't write to update file at #{event.payload[:path]}"

      Mailer.file_write_error(event.payload[:path], "can't write to file").deliver
    end

    # No permission to write update file
    def write_permission_error(event)
      error "No permission to write update to #{event.payload[:path]}"

      Mailer.file_write_error(event.payload[:path], 'permission error').deliver
    end

    # Delayed update fetching
    def delay_download(event)
      info "Delaying update fetching: #{event.payload[:url]}"
    end

    # We missed three update files in a row
    # Might be okay for Taric, but most likely not ok for CHIEF
    # this is precautionary measure
    def missing_updates(event)
      warn "Missing #{event.payload[:count]} updates in a row for #{event.payload[:update_type].to_s.upcase}"

      Mailer.missing_updates(event.payload[:count], event.payload[:update_type].to_s).deliver
    end
  end
end

TariffSynchronizer::Logger.attach_to :tariff_synchronizer
