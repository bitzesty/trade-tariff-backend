module Sequel
  module Plugins
    module TariffValidationHelpers
      module InstanceMethods 
        def validates_start_date
          if validity_start_date && validity_end_date && (validity_end_date < validity_start_date)
            errors.add(:validity_start_date, 'must be less then or equal to end date')
          end
        end
      end
    end
  end
end