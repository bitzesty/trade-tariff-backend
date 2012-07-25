class DutyExpressionFormatter
  def self.format(duty_expression_id, duty_amount, monetary_unit, measurement_unit, measurement_unit_qualifier)
    @formatted = case duty_expression_id
                 when "01"
                   if monetary_unit.present? && measurement_unit.present?
                     sprintf("%.2f %s/%s", duty_amount, monetary_unit, measurement_unit.description)
                   else
                     sprintf("%.2f%", duty_amount)
                   end
                 when "04"
                   sprintf("+ %.2f %s/%s", duty_amount,
                                           monetary_unit,
                                           measurement_unit.description)
                 when "12"
                   "+ EA"
                 when "14"
                   "+ EA R"
                 when "15"
                   sprintf("min %.2f %s/(%s/%s)", duty_amount,
                                                  monetary_unit,
                                                  measurement_unit.description,
                                                  measurement_unit_qualifier.description)
                 when "17"
                   sprintf("max %.2f%", duty_amount)
                 when "19"
                   sprintf("+ %.2f %s/%s", duty_amount,
                                           monetary_unit,
                                           measurement_unit.description)
                 when "21"
                   "+ AD S/Z"
                 when "25"
                   "+ AD S/Z R"
                 when "27"
                   "+ AD F/M"
                 when "29"
                   "+ AD F/M R"
                 when "35"
                   sprintf("max %.2f %s/%s", duty_amount,
                                             monetary_unit,
                                             measurement_unit.description)
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
                   measurement_unit.description
                 end
  end
end
