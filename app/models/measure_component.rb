class MeasureComponent < Sequel::Model
  plugin :time_machine

  set_primary_key :measure_sid, :duty_expression_id

  one_to_one :duty_expression, key: {}, primary_key: {}, dataset: -> {
    actual(DutyExpression)
                  .where(duty_expression_id: duty_expression_id)
  }

  # belongs_to :measure, foreign_key: :measure_sid
  # belongs_to :measurement_unit, foreign_key: :measurement_unit_code
  # belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  # belongs_to :duty_expression, foreign_key: :duty_expression_id
  # belongs_to :monetary_unit, foreign_key: :monetary_unit_code
end


