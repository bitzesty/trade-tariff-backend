class MeasurementUnitQualifierDescription < Sequel::Model
  set_primary_key :measurement_unit_qualifier_code

  # belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  # belongs_to :language
end


