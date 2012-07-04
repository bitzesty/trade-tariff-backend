class MeasureTypeDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number
  
  belongs_to :measure_type
  belongs_to :language
end
