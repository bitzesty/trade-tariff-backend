class MeasureConditionComponent < Sequel::Model
  set_primary_key [:measure_condition_sid, :duty_expression_id]

  # belongs_to :duty_expression, foreign_key: :duty_expression_id
  # belongs_to :measure_condition, foreign_key: :measure_condition_sid
  # belongs_to :measurement_unit, foreign_key: :measurement_unit_code
  # belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  # belongs_to :monetary_unit, foreign_key: :monetary_unit_code
end


