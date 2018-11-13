FactoryGirl.define do
  factory :measure_condition_code_description do
    condition_code { Forgery(:basic).text(exactly: 1) }
    description { Forgery(:basic).text(exactly: 10) }
  end
end
