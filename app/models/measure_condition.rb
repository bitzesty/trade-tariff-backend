class MeasureCondition < ActiveRecord::Base
  self.primary_key = :measure_condition_sid

  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :measure_action, foreign_key: :action_code
  belongs_to :measure_condition_code, foreign_key: :condition_code
end
