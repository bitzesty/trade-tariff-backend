class MeasurementUnitDescription < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :measurement_unit, foreign_key: :measurement_unit_code
  belongs_to :language
end
