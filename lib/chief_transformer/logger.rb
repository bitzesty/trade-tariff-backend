class ChiefTransformer
  class Logger < ActiveSupport::LogSubscriber
    cattr_accessor :logger
    self.logger = ::Logger.new('log/chief_transformer.log')
    self.logger.formatter = TradeTariffBackend.log_formatter

    def start_transform(event)
      info "CHIEF Transformer started in #{event.payload[:mode]} mode"
    end

    def transform(event)
      if event.payload.has_key?(:exception)
        error "CHIEF Transformer failed #{event.payload[:exception]}"
      else
        info "CHIEF Transformer finished successfully in #{event.duration}s"
      end
    end

    def process(event)
      if event.payload.has_key?(:exception)
        error "Failed to process: #{event.payload[:operation]}. Exception: #{event.payload[:exception]}"
      else
        info "Processing: #{event.payload[:operation]}"
      end
    end
  end
end

ChiefTransformer::Logger.attach_to :chief_transformer
