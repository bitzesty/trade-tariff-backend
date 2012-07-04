class MeasurementUnitQualifierDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  belongs_to :language
end
