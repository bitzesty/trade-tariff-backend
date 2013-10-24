class RequirementDutyExpressionFormatter
  def self.prettify(float)
    sprintf("%.2f", float)
  end

  def self.format(opts={})
    duty_amount = opts[:duty_amount]
    monetary_unit = opts[:monetary_unit_abbreviation].presence || opts[:monetary_unit]
    measurement_unit = opts[:measurement_unit]
    measurement_unit_qualifier = opts[:formatted_measurement_unit_qualifier]

    output = []

    if duty_amount.present?
      output << prettify(duty_amount).to_s
    end

    if monetary_unit.present? && measurement_unit.present? && measurement_unit_qualifier.present?
      output << "#{monetary_unit}/(#{measurement_unit}/#{measurement_unit_qualifier})"
    elsif monetary_unit.present? && measurement_unit.present?
      output << "#{monetary_unit}/#{measurement_unit}"
    elsif measurement_unit.present?
      output << measurement_unit
    end
    output.join(" ").html_safe
  end
end
