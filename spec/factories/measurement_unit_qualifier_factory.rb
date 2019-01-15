FactoryGirl.define do
  factory :measurement_unit_qualifier do
    measurement_unit_qualifier_code { generate(:measurement_unit_qualifier_code) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :xml do
      validity_end_date { Date.today.ago(1.years) }
    end
  end

  factory :measurement_unit_qualifier_description do
    measurement_unit_qualifier_code { generate(:measurement_unit_qualifier_code) }
    description { Forgery(:lorem_ipsum).sentence }

    trait :xml do
      language_id { "EN" }
    end
  end
end
