FactoryGirl.define do
  factory :measurement_unit_abbreviation do
    abbreviation { Forgery(:basic).text }
    measurement_unit_code { Forgery(:basic).text(exactly: 3) }

    trait :with_measurement_unit do
      after(:create) do |measurement_unit_abbreviation|
        FactoryGirl.create(:measurement_unit, measurement_unit_code: measurement_unit_abbreviation.measurement_unit_code)
      end
    end

    trait :include_qualifier do
      measurement_unit_qualifier { Forgery(:basic).text(exactly: 1) }
    end
  end
end
