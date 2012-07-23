class MeasurementUnitDescription < Sequel::Model
  set_primary_key  :measurement_unit_code

  # belongs_to :measurement_unit, foreign_key: :measurement_unit_code
  # belongs_to :language
end


