class MeasurementUnitDescription < ActiveRecord::Base
  belongs_to :measurement_unit, foreign_key: :measurement_unit_code
end
