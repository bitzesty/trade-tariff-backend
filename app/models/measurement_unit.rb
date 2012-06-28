class MeasurementUnit < ActiveRecord::Base
  self.primary_key = :measurement_unit_code

  has_one :description, foreign_key: :measurement_unit_code,
                        class_name: 'MeasurementUnitDescription'
end
