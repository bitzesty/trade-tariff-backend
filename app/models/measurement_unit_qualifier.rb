class MeasurementUnitQualifier < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :description, foreign_key: :measurement_unit_qualifier_code,
                        class_name: 'MeasurementUnitQualifierDescription'
  has_one :measurement, foreign_key: :measurement_unit_qualifier_code
  has_many :quota_definitions, foreign_key: :measurement_unit_qualifier_code
end
