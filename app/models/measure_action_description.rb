class MeasureActionDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number
  
  belongs_to :measure_action, foreign_key: :action_code
  belongs_to :language
end
