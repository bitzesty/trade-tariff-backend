FactoryGirl.define do
  sequence(:measure_condition_component) { |n| n}

  factory :measure_condition_component do
    measure_condition_sid           { generate(:measure_condition_component) }
    duty_expression_id              { Forgery(:basic).text(exactly: 2) }
    duty_amount                     { Forgery(:basic).number }
    monetary_unit_code              { Forgery(:basic).text(exactly: 3) }
    measurement_unit_code           { Forgery(:basic).text(exactly: 3) }
    measurement_unit_qualifier_code { Forgery(:basic).text(exactly: 1) }
  end
end
