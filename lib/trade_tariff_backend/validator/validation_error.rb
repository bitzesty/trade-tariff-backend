module TradeTariffBackend
  class Validator
    class ValidationError < StandardError
      def initialize(record)
        super("#{record.inspect} errors: #{record.errors.inspect}")
      end
    end
  end
end
