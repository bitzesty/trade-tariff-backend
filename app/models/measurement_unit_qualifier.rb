class MeasurementUnitQualifier < Sequel::Model
  set_primary_key  :measurement_unit_qualifier_code

  # has_many :measure_components, foreign_key: :measurement_unit_qualifier_code
  # has_many :quota_definitions, foreign_key: :measurement_unit_qualifier_code
  # has_many :measure_condition_components, foreign_key: :measurement_unit_qualifier_code
  # has_many :measure_conditions, foreign_key: :condition_measurement_unit_qualifier_code
  # has_many :measurements, foreign_key: :measurement_unit_qualifier_code
  # has_one  :measurement_unit_qualifier_description, foreign_key: :measurement_unit_qualifier_code
end


