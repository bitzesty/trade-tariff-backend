FactoryGirl.define do
  sequence(:measure_sid) { |n| n}

  factory :measure do
    measure_sid  { generate(:measure_sid) }
    measure_type_id { generate(:measure_sid) }
    measure_generating_regulation_id { generate(:measure_sid) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :with_measure_type do
      after(:create) { |measure, evaluator|
        FactoryGirl.create(:measure_type, measure_type_id: measure.measure_type_id)
      }
    end

    trait :with_base_regulation do
      after(:create) { |measure, evaluator|
        FactoryGirl.create(:base_regulation, base_regulation_id: measure.measure_generating_regulation_id)
      }
    end
  end

  factory :measure_type do
    measure_type_id        { Forgery(:basic).text(exactly: 3) }
    measure_type_series_id { Forgery(:basic).text(exactly: 1) }
    validity_start_date    { Date.today.ago(3.years) }
    validity_end_date      { nil }

    trait :export do
      trade_movement_code { 1 }
    end

    trait :import do
      trade_movement_code { 0 }
    end
  end

  factory :measure_condition do
    measure_condition_sid { generate(:measure_sid) }
    measure_sid { generate(:measure_sid) }
    condition_code     { Forgery(:basic).text(exactly: 2) }
    component_sequence_number     { Forgery(:basic).number }
    condition_duty_amount     { Forgery(:basic).number }
    condition_monetary_unit_code     { Forgery(:basic).text(exactly: 3) }
    condition_measurement_unit_code     { Forgery(:basic).text(exactly: 3) }
    condition_measurement_unit_qualifier_code     { Forgery(:basic).text(exactly: 1) }
    action_code     { Forgery(:basic).text(exactly: 1) }
    certificate_type_code     { Forgery(:basic).text(exactly: 1) }
    certificate_code     { Forgery(:basic).text(exactly: 3) }
  end
end
