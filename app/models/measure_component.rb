class MeasureComponent < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: [:measure_sid, :duty_expression_id]

  set_primary_key :measure_sid, :duty_expression_id

  one_to_one :duty_expression, key: :duty_expression_id,
                               primary_key: :duty_expression_id do |ds|
    ds.with_actual(DutyExpression)
  end

  one_to_one :measurement_unit, key: :measurement_unit_code,
                                primary_key: :measurement_unit_code do |ds|
    ds.with_actual(MeasurementUnit)
  end

  one_to_one :monetary_unit, key: :monetary_unit_code,
                             primary_key: :monetary_unit_code do |ds|
    ds.with_actual(MonetaryUnit)
  end

  one_to_one :measurement_unit_qualifier, key: :measurement_unit_qualifier_code,
                                          primary_key: :measurement_unit_qualifier_code do |ds|
    ds.with_actual(MeasurementUnitQualifier)
  end

  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid

  delegate :description, :abbreviation, to: :duty_expression, prefix: true
  delegate :abbreviation, to: :monetary_unit, prefix: true, allow_nil: true

  def duty_rate
    opts = {
      duty_amount: duty_amount,
      duty_expression_id: duty_expression_id,
      duty_expression_description: duty_expression.description,
      duty_expression_abbreviation: duty_expression.abbreviation,
      monetary_unit: monetary_unit,
      monetary_unit_abbreviation: monetary_unit.try(:abbreviation),
      measurement_unit: measurement_unit,
      formatted_measurement_unit_qualifier: nil
    }

    DutyExpressionFormatter.format(opts)
  end
end


