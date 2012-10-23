FactoryGirl.define do
  factory :duty_expression do
    duty_expression_id { Forgery(:basic).number }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end
end
