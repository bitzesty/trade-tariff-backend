FactoryGirl.define do
  factory :measurement do
    measurement_unit_code           { Forgery(:basic).text(exactly: 2) }
    measurement_unit_qualifier_code { generate(:measurement_unit_qualifier_code) }
    validity_start_date             { Date.today.ago(3.years) }
    validity_end_date               { nil }

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end
end
