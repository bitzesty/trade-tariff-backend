module TariffSynchronizer
  class Logger < ActiveSupport::LogSubscriber
    # Download all pending Taric and Chief updates
    def download(_event)
      info "Finished downloading updates"
    end

    # Sync variables were not set correctly
    def config_error(_event)
      error "Missing: Tariff sync enviroment variables: TARIFF_SYNC_USERNAME, TARIFF_SYNC_PASSWORD, TARIFF_SYNC_HOST and TARIFF_SYNC_EMAIL."
    end

    # There are failed updates (can't proceed)
    def failed_updates_present(event)
      error "TariffSynchronizer found failed updates that need to be fixed before running: #{event.payload[:file_names]}"
    end

    # Apply all pending Taric and Chief updates
    def apply(event)
      info "Finished applying updates"

      Mailer.applied(
        event.payload[:update_names],
        event.payload.fetch(:unconformant_records, [])
      ).deliver_now
    end

    def apply_lock_error(_event)
      warn "Failed to acquire Redis lock for update application"
    end

    # Update failed to be applied
    def failed_update(event)
      error "Update failed: #{event.payload[:update]}"

      Mailer.exception(
        event.payload[:exception],
        event.payload[:update],
        event.payload[:database_queries]
      ).deliver_now
    end

    def rollback(event)
      info "Rolled back to #{event.payload[:date]}. Forced keeping records: #{!!event.payload[:keep]}"
    end

    def rollback_lock_error(event)
      warn "Failed to acquire Redis lock for rollback to #{event.payload[:date]}. Keep records: #{event.payload[:keep]}"
    end

    # Update download failed
    def failed_download(event)
      exception = event.payload[:exception]
      error "Download failed: #{exception.original}, url: #{exception.url}"
      Mailer.failed_download(exception.original, exception.url).deliver_now
    end

    # Exceeded retry count
    def retry_exceeded(event)
      warn "Download retry count exceeded for #{event.payload[:url]}"

      Mailer.retry_exceeded(event.payload[:url], event.payload[:date]).deliver_now
    end

    # Update not found
    def not_found(event)
      warn "Update not found for #{event.payload[:date]} at #{event.payload[:url]}"
    end

    def created_tariff(event)
      info "Created/Updated #{event.payload[:type].upcase} entry for #{event.payload[:date]} and #{event.payload[:filename]}"
    end

    # Apply CHIEF update
    def apply_chief(event)
      info "Applied CHIEF update #{event.payload[:filename]}"
    end

    # Apply TARIC update
    def apply_taric(event)
      info "Applied TARIC update #{event.payload[:filename]}"
    end

    # Query for TARIC update path
    def get_taric_update_name(event)
      info "Checking for TARIC update for #{event.payload[:date]} at #{event.payload[:url]}"
    end

    def downloaded_tariff_update(event)
      info "#{event.payload[:type].upcase} update for #{event.payload[:date]} downloaded from #{event.payload[:url]}, to #{event.payload[:path]} (size: #{event.payload[:size]})"
    end

    # Update with blank content received
    def blank_update(event)
      error "Blank update content received for #{event.payload[:date]}: #{event.payload[:url]}"

      Mailer.blank_update(event.payload[:url], event.payload[:url]).deliver_now
    end

    # Delayed update fetching
    def delay_download(event)
      info "Delaying update fetching: #{event.payload[:url]} (response code: #{event.payload[:response_code]})"
    end

    # Problems downloading
    def download_exception(event)
      info "Delaying update fetching: #{event.payload[:url]} (reason: #{event.payload[:class]})"
    end

    # Problems downloading
    def download_exception_exceeded(event)
      info "Giving up fetching: #{event.payload[:url]}, too many DownloadExceptions"
    end

    # We missed three update files in a row
    # Might be okay for Taric, but most likely not ok for CHIEF
    # this is precautionary measure
    def missing_updates(event)
      warn "Missing #{event.payload[:count]} updates in a row for #{event.payload[:update_type].to_s.upcase}"

      Mailer.missing_updates(event.payload[:count], event.payload[:update_type].to_s).deliver_now
    end
  end
end

TariffSynchronizer::Logger.attach_to :tariff_synchronizer
