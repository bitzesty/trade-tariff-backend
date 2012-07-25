class DutyExpressionFormatter
  def self.format(measure_component)
    @formatted = case measure_component.duty_expression_id
                 when "01"
                   if measure_component.monetary_unit_code.present? && measure_component.measurement_unit_code.present?
                     sprintf("%.2f %s/%s", measure_component.duty_amount, measure_component.monetary_unit_code, measure_component.measurement_unit.description)
                   else
                     sprintf("%.2f%", measure_component.duty_amount)
                   end
                 when "04"
                   sprintf("+ %.2f %s/%s", measure_component.duty_amount,
                                            measure_component.monetary_unit,
                                            measure_component.measurement_unit.description)
                 when "12"
                   "+ EA"
                 when "14"
                   "+ EA R"
                 when "15"
                   sprintf("min %.2f %s/(%s/%s)", measure_component.duty_amount,
                                                  measure_component.monetary_unit,
                                                  measure_component.measurement_unit.description,
                                                  measure_component.measurement_unit_qualifier.description)
                 when "17"
                   sprintf("max %.2f%", measure_component.duty_amount)
                 when "19"
                   sprintf("+ %.2f %s/%s", measure_component.duty_amount,
                                            measure_component.monetary_unit,
                                            measure_component.measurement_unit.description)
                 when "21"
                   "+ AD S/Z"
                 when "25"
                   "+ AD S/Z R"
                 when "27"
                   "+ AD F/M"
                 when "29"
                   "+ AD F/M R"
                 when "35"
                   sprintf("max %.2f %s/%s", measure_component.duty_amount,
                                             measure_component.monetary_unit,
                                             measure_component.measurement_unit.description)
                 when "37"
                   # Empty
                 when "40"
                   # TODO Empty, check 21050099 for export
                 when "41"
                   # TODO Empty, check 21050099 for export
                 when "42"
                   # TODO Empty, check 21050099 for export
                 when "43"
                   # TODO Empty, check 21050099 for export
                 when "44"
                   # TODO Empty, check 21050099 for export
                 when "99"
                   measure_component.measurement_unit.description
                 end
  end
end
