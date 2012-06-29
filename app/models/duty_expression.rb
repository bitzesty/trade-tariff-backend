class DutyExpression < ActiveRecord::Base
  self.primary_key = :duty_expression_id

  has_many :measures
  has_many :measure_components
  has_many :measure_condition_components
end
