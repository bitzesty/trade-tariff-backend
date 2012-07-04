class MeasureConditionCodeDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :language
  belongs_to :measure_condition_code, foreign_key: :condition_code
end
