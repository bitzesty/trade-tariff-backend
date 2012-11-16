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
      unless event.payload.has_key?(:exception)
        info "Processed: #{event.payload[:operation].inspect}"
      end
    end

    def exception(event)
      error "Could not transform: #{event.payload[:operation].inspect}. \n #{event.payload[:exception]} \nBacktrace: \n#{event.payload[:exception].backtrace.join("\n")}"
    end
  end
end

ChiefTransformer::Logger.attach_to :chief_transformer
