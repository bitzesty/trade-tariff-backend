class MeasureActionDescription < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :measure_action, foreign_key: :action_code
  belongs_to :language
end
