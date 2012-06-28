class MeasurementUnitQualifier < ActiveRecord::Base
  self.primary_key = :measurement_unit_qualifier_code

  has_one :description, foreign_key: :measurement_unit_qualifier_code,
                        class_name: 'MeasurementUnitQualifierDescription'
end
