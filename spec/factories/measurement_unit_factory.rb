FactoryGirl.define do
  factory :measurement_unit do
    transient do
      description { Forgery(:basic).text }
    end

    measurement_unit_code { Forgery(:basic).text(exactly: 3) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :with_description do
      after(:create) { |measurement_unit, evaluator|
        FactoryGirl.create :measurement_unit_description,
          measurement_unit_code: measurement_unit.measurement_unit_code,
          description: evaluator.description
      }
    end
  end

  factory :measurement_unit_description do
    measurement_unit_code { Forgery(:basic).text(exactly: 3) }
    description { Forgery(:basic).text }
  end
end
