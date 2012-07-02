class MeasureConditionComponent < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :measure_condition, foreign_key: :measure_condition_sid
  belongs_to :duty_expression
end
