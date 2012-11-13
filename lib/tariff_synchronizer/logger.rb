module TariffSynchonizer
  class Logger < ActiveSupport::LogSubscriber
    cattr_accessor :logger
    self.logger = ::Logger.new('log/sync.log')
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
    end

    # Apply all pending Taric and Chief updates
    def apply(event)
      info "Finished applying updates"
    end

    # Update failed to be applied
    def failed_update(event)
      error "Update failed: #{event.payload[:update]}"
    end

    # Update rebuild from files present in the file system
    def rebuild(event)
      info "Rebuilding updates from file system"
    end

    # Update with blank content received
    def blank_update(event)
      error "Blank update content received for #{event.payload[:date]}: #{event.payload[:filename]}"
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

    # Taric update not found
    def not_found_taric(event)
      warn "TARIC update not found for #{event.payload[:date]}"
    end

    # CHIEF update not found
    def not_found_chief(event)
      warn "CHIEF update not found for #{event.payload[:date]}"
    end

    # Apply TARIC update
    def apply_taric(event)
      info "Applied TARIC update #{event.payload[:filename]}"
    end

    # Query for TARIC update path
    def get_path_taric(event)
      info "Checking for TARIC update for #{event.payload[:date]} at #{event.payload[:url]}"
    end

    # Update file written to file system
    def file_written(event)
      info "Update file written to file system: #{event.payload[:path]}"
    end

    # Can't open file for writing
    def cant_open_file(event)
      error "Can't open file for writting update at #{event.payload[:path]}"
    end

    # Can't write to file
    def cant_write_to_file(event)
      error "Can't write to update file at #{event.payload[:path]}"
    end

    # No permission to write update file
    def write_permission_error(event)
      error "No permission to write update to #{event.payload[:path]}"
    end

    # Delayed update fetching
    def delay_download(event)
      warn "Delaying update fetching: #{event.payload[:url]}"
    end
  end
end

TariffSynchonizer::Logger.attach_to :tariff_synchronizer
