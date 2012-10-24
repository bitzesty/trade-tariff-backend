module Sequel
  module Plugins
    module TariffValidationHelpers
      module InstanceMethods
        def validates_start_date
          if validity_start_date && validity_end_date && (validity_end_date < validity_start_date)
            errors.add(:validity_start_date, 'must be less then or equal to end date')
          end
        end

        def validates_validity_date_span_of(measure_type)
          errors.add(:validity_start_date, "must be greater or equal to #{measure_type.validity_start_date}") if validity_start_date < measure_type.validity_start_date
          errors.add(:validity_end_date, "must be less or equal to #{measure_type.validity_end_date}") if validity_end_date > measure_type.validity_end_date
        end
      end
    end
  end
end
