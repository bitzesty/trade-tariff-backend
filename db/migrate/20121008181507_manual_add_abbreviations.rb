Sequel.migration do
  up do
    DutyExpressionDescription.where(duty_expression_id: "01").update(abbreviation: "%")
    DutyExpressionDescription.where(duty_expression_id: "02").update(abbreviation: "-")
    DutyExpressionDescription.where(duty_expression_id: "04").update(abbreviation: "+")
    DutyExpressionDescription.where(duty_expression_id: "12").update(abbreviation: "+ EA")
    DutyExpressionDescription.where(duty_expression_id: "14").update(abbreviation: "+ EAR")
    DutyExpressionDescription.where(duty_expression_id: "15").update(abbreviation: "MIN")
    DutyExpressionDescription.where(duty_expression_id: "17").update(abbreviation: "MAX")
    DutyExpressionDescription.where(duty_expression_id: "19").update(abbreviation: "+")
    DutyExpressionDescription.where(duty_expression_id: "20").update(abbreviation: "+")
    DutyExpressionDescription.where(duty_expression_id: "21").update(abbreviation: "+ADSZ")
    DutyExpressionDescription.where(duty_expression_id: "25").update(abbreviation: "+ADSZR")
    DutyExpressionDescription.where(duty_expression_id: "27").update(abbreviation: "+ADFM")
    DutyExpressionDescription.where(duty_expression_id: "29").update(abbreviation: "+ADFMR")
    DutyExpressionDescription.where(duty_expression_id: "35").update(abbreviation: "MAX")
    DutyExpressionDescription.where(duty_expression_id: "36").update(abbreviation: "-")
    DutyExpressionDescription.where(duty_expression_id: "37").update(abbreviation: "NIHIL")
    DutyExpressionDescription.where(duty_expression_id: "40").update(abbreviation: "ERCER")
    DutyExpressionDescription.where(duty_expression_id: "41").update(abbreviation: "ERRIS")
    DutyExpressionDescription.where(duty_expression_id: "42").update(abbreviation: "EREGG")
    DutyExpressionDescription.where(duty_expression_id: "43").update(abbreviation: "ERSUG")
    DutyExpressionDescription.where(duty_expression_id: "44").update(abbreviation: "ERMLK")
    DutyExpressionDescription.where(duty_expression_id: "99").update(abbreviation: "UNSUP")
  end

  down do
  end
end
