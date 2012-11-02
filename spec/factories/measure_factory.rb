FactoryGirl.define do
  sequence(:measure_sid) { |n| n}

  factory :measure do
    measure_sid  { generate(:measure_sid) }
    measure_type_id { generate(:measure_sid) }
    measure_generating_regulation_id { generate(:base_regulation_sid) }
    measure_generating_regulation_role { Measure::VALID_ROLE_TYPE_IDS.sample }
    goods_nomenclature_sid { generate(:goods_nomenclature_sid) }
    geographical_area_sid { generate(:geographical_area_sid) }
    geographical_area_id { Forgery(:basic).text(exactly: 2).upcase }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :with_goods_nomenclature do
      after(:create) { |measure, evaluator|
        FactoryGirl.create(:goods_nomenclature, goods_nomenclature_sid: measure.goods_nomenclature_sid,
                                                goods_nomenclature_item_id: measure.goods_nomenclature_item_id,
                                                producline_suffix: "80",
                                                validity_start_date: measure.validity_start_date)
      }
    end

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

    trait :with_geographical_area do
      after(:create) { |measure, evaluator|
        FactoryGirl.create(:geographical_area, geographical_area_sid: measure.geographical_area_sid,
                                               geographical_area_id: measure.geographical_area_id)
      }
    end
  end

  factory :measure_type do
    measure_type_id        { Forgery(:basic).text(exactly: 3) }
    validity_start_date    { Date.today.ago(3.years) }
    validity_end_date      { nil }
    measure_explosion_level { 10 }

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
