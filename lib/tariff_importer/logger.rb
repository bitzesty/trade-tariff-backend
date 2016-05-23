module TariffImporter
  class Logger < ActiveSupport::LogSubscriber

    def chief_imported(event)
      info "Parsed #{event.payload[:count]} CHIEF records from #{event.payload[:filename]}"
    end

    def chief_failed(event)
      error "CHIEF import of #{event.payload[:filename]} failed: Reason: #{event.payload[:exception]}"
    end

    def taric_failed(event)
      "Taric import failed: #{event.payload[:exception]}".tap {|message|
        message << "\n Failed transaction:\n #{event.payload[:hash]}"
        message << "\n Backtrace:\n #{event.payload[:exception].backtrace.join("\n")}"
        error message
      }
    end

    def taric_imported(event)
      info "Successfully imported Taric file: #{event.payload[:filename]}"
    end

    def taric_unexpected_update_type(event)
      error "Unexpected Taric operation type: #{event.payload[:record].inspect}"
    end
  end
end

TariffImporter::Logger.attach_to :tariff_importer
