class MeasureConditionCodeDescription < ActiveRecord::Base
  belongs_to :language
  belongs_to :measure_condition_code, foreign_key: :condition_code
end
