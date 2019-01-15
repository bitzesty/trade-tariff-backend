FactoryGirl.define do
  factory :monetary_unit do
    monetary_unit_code { Forgery(:basic).text(exactly: 3) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :with_description do
      after(:create) { |monetary_unit, _evaluator|
        FactoryGirl.create :monetary_unit_description, monetary_unit_code: monetary_unit.monetary_unit_code
      }
    end
  end

  factory :monetary_unit_description do
    monetary_unit_code { Forgery(:basic).text(exactly: 3) }
    description        { Forgery(:basic).text }
  end
end
