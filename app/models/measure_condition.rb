class MeasureCondition < Sequel::Model
  plugin :time_machine
  plugin :national
  plugin :timestamps

  set_primary_key :measure_condition_sid

  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid

  one_to_one :measure_action, primary_key: :action_code,
                              key: :action_code do |ds|
    ds.with_actual(MeasureAction)
  end

  one_to_one :certificate, key: :certificate_code,
                           primary_key: :certificate_code do |ds|
    ds.with_actual(Certificate)
  end


  one_to_one :certificate_type, key: :certificate_type_code,
                                primary_key: :certificate_type_code do |ds|
    ds.with_actual(CertificateType)
  end

  one_to_one :measurement_unit, primary_key: :condition_measurement_unit_code,
                                key: :measurement_unit_code do |ds|
    ds.with_actual(MeasurementUnit)
  end

  one_to_one :monetary_unit, primary_key: :condition_monetary_unit_code,
                             key: :monetary_unit_code do |ds|
    ds.with_actual(MonetaryUnit)
  end

  one_to_one :measurement_unit_qualifier, primary_key: :condition_measurement_unit_qualifier_code,
                                          key: :measurement_unit_qualifier_code do |ds|
    ds.with_actual(MeasurementUnitQualifier)
  end

  one_to_one :measure_condition_code, key: :condition_code,
                                      primary_key: :condition_code do |ds|
    ds.with_actual(MeasureConditionCode)
  end

  one_to_many :measure_condition_components, key: :measure_condition_sid,
                                             primary_key: :measure_condition_sid


  delegate :monetary_unit_abbreviation, to: :monetary_unit, allow_nil: true

  def before_create
    self.measure_condition_sid ||= self.class.next_national_sid

    super
  end

  def document_code
    "#{certificate_type_code}#{certificate_code}"
  end

  def requirement
    case requirement_type
    when :document
      {
        certificate: certificate.try(:description),
        certificate_type: certificate_type.try(:description)
      }
    when :duty_expression
      {
        sequence_number: component_sequence_number,
        duty_amount: condition_duty_amount,
        monetary_unit: condition_monetary_unit_code,
        monetary_unit_abbreviation: monetary_unit_abbreviation,
        measurement_unit: measurement_unit.try(:description),
        measurement_unit_qualifier: measurement_unit_qualifier.try(:description)
      }
    end
  end

  def action
    measure_action.try(:description)
  end

  def condition
    measure_condition_code.try(:description)
  end

  def requirement_type
    if certificate_code.present?
      :document
    elsif condition_duty_amount.present?
      :duty_expression
    end
  end
end
