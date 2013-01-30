class ChiefTransformer
  class Logger < ActiveSupport::LogSubscriber
    cattr_accessor :logger
    self.logger = ::Logger.new('log/chief_transformer.log')
    self.logger.formatter = TradeTariffBackend.log_formatter

    def start_transform(event)
      info "CHIEF Transformer started in #{event.payload[:mode]} mode"
    end

    def process(event)
      unless event.payload.has_key?(:exception)
        info "Processed: #{event.payload[:operation].inspect}"
      end
    end

    def invalid_operation(event)
      error "Could not transform #{event.payload[:operation].inspect}. \nFailed model: #{event.payload[:model].inspect}. \nErrors: #{event.payload[:errors].inspect}. \nException: #{event.payload[:exception]}. \nBacktrace: #{event.payload[:exception].backtrace.join("\n")}"

      Mailer.failed_transformation_notice(event.payload[:operation],
                                          event.payload[:exception],
                                          event.payload[:model],
                                          event.payload[:errors]).deliver
    end
  end
end

ChiefTransformer::Logger.attach_to :chief_transformer
