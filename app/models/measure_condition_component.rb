class MeasureConditionComponent < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :measure_condition, foreign_key: :measure_condition_sid
  belongs_to :duty_expression
end
