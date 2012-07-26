class MeasureCondition < Sequel::Model
  plugin :time_machine

  set_primary_key :measure_condition_sid

  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid

  one_to_one :measure_action, dataset: -> {
    actual(MeasureAction)
                 .where(action_code: action_code)
  }

  one_to_one :certificate, dataset: -> {
    actual(Certificate).where(certificate_code: certificate_code,
                      certificate_type_code: certificate_type_code)
  }

  one_to_one :duty_expression, key: {}, primary_key: {}, dataset: -> {
    actual(DutyExpression)
                  .where(duty_expression_id: duty_expression_id)
  }

  one_to_one :measurement_unit, key: {}, primary_key: {}, dataset: -> {
    actual(MeasurementUnit)
                  .where(measurement_unit_code: condition_measurement_unit_code)
  }

  one_to_one :monetary_unit, key: {}, primary_key: {}, dataset: -> {
    actual(MonetaryUnit)
                  .where(monetary_unit_code: condition_monetary_unit_code)
  }

  one_to_one :measurement_unit_qualifier, key: {}, primary_key: {}, dataset: -> {
    actual(MeasurementUnitQualifier)
                  .where(measurement_unit_qualifier_code: condition_measurement_unit_qualifier_code)
  }

  one_to_one :measure_condition_code, key: {}, primary_key: {}, dataset: -> {
    actual(MeasureConditionCode)
                  .where(condition_code: condition_code)
  }

  one_to_many :measure_condition_components, key: :measure_condition_sid,
                                             primary_key: :measure_condition_sid


  def document_code
    "#{certificate_type_code}#{certificate_code}"
  end

  def requirement
    case requirement_type
    when :document
      {
        requirement: certificate.description
      }
    when :duty_expression
      {
        sequence_number: component_sequence_number,
        condition_amount: condition_duty_amount,
        monetary_unit: condition_monetary_unit_code,
        measurement_unit: measurement_unit.try(:description),
        measurement_unit_qualifier: measurement_unit_qualifier.try(:description)
      }
    end
  end

  def action
    measure_action.description
  end

  def condition
    measure_condition_code.description
  end

  def components
  end

  def requirement_type
    if certificate_code.present?
      :document
    elsif condition_duty_amount.present?
      :duty_expression
    end
  end

  def as_duty_expression
    DutyExpressionFormatter.format(duty_expression_id, duty_amount, monetary_unit,
                                   measurement_unit, measurement_unit_qualifier)
  end
end


