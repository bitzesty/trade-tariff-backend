module TradeTariffBackend
  module Validations
    class InclusionValidation < GenericValidation
      def valid?(record = nil)
        include_in = validation_options[:in]
        inclusion_of = validation_options[:of]

        raise ArgumentError.new('validates :inclusion expects {in: ARRAY} and {of: :symbol} to be passed in with options') if include_in.blank? || inclusion_of.blank?
        include_in.include?(record.send(inclusion_of))
      end
    end
  end
end
