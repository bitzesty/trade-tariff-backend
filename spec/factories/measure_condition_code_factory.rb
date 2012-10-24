FactoryGirl.define do
  factory :measure_condition_code do
    condition_code { Forgery(:basic).text(exactly: 1) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end
end
