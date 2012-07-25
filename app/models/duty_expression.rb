class DutyExpression < Sequel::Model
  plugin :time_machine

  set_primary_key :duty_expression_id

  one_to_one :duty_expression_description

  delegate :description, to: :duty_expression_description

  # has_many :measure_components, foreign_key: :duty_expression_id
  # has_many :measures, through: :measure_components
  # has_many :measure_condition_components, foreign_key: :duty_expression_id
  # has_one  :duty_expression_description, foreign_key: :duty_expression_id
end


