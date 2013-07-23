FactoryGirl.define do
  sequence(:duty_expression_description) { |n| n }

  factory :duty_expression do
    duty_expression_id  { generate(:duty_expression_description) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :duty_expression_description do
    duty_expression_id  { generate(:duty_expression_description) }
    description         { Forgery(:basic).text }
  end
end
