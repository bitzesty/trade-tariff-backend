module TradeTariffBackend
  module Validations
    class ValidityDatesValidation < GenericValidation
      def valid?(record = nil)
        if record.validity_start_date && record.validity_end_date
          record.validity_start_date <= record.validity_end_date
        else
          true
        end
      end
    end
  end
end
