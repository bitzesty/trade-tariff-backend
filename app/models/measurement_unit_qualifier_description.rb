class MeasurementUnitQualifierDescription < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  belongs_to :language
end
