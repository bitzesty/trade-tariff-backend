class MeasureConditionCodeDescription < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :language
  belongs_to :measure_condition_code, foreign_key: :condition_code
end
