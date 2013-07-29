class TariffImporter
  class Logger < ActiveSupport::LogSubscriber
    cattr_accessor :logger
    self.logger = ::Logger.new('log/tariff_importer.log')
    self.logger.formatter = TradeTariffBackend.log_formatter

    def chief_imported(event)
      info "Parsed #{event.payload[:count]} CHIEF records for #{event.payload[:date]} at #{event.payload[:path]}"
    end

    def chief_failed(event)
      error "CHIEF import of #{File.join(Rails.root, event.payload[:path])} failed: Reason: #{event.payload[:exception]}"
    end

    def taric_failed(event)
      "Taric import failed: #{event.payload[:exception]}".tap {|message|
        message << "\n Failed transaction: #{event.payload[:xml]}" if event.payload.has_key?(:xml)
        message << "Backtrace:\n #{event.payload[:exception].backtrace.join("\n")}"
        error message
      }
    end

    def taric_imported(event)
      info "Successfully imported Taric file at #{event.payload[:path]}" unless event.payload.has_key?(:exception)
    end

    def taric_unexpected_update_type(event)
      error "Unexpected Taric operation type: #{event.payload[:record].inspect}"
    end
  end
end

TariffImporter::Logger.attach_to :tariff_importer
