class MeasureConditionComponent < ActiveRecord::Base
  belongs_to :measure_condition, foreign_key: :measure_condition_sid
  belongs_to :duty_expression
end
