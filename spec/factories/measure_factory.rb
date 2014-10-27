FactoryGirl.define do
  sequence(:measure_sid) { |n| n}
  sequence(:measure_type_id) { |n| n}
  sequence(:measure_condition_sid) { |n| n}

  factory :measure do |f|
    transient do
      type_explosion_level { 10 }
      gono_number_indents { 1 }
      gono_producline_suffix { "80" }
      order_number_capture_code { 2 }
    end

    f.measure_sid  { generate(:measure_sid) }
    f.measure_type_id { generate(:measure_type_id) }
    f.measure_generating_regulation_id { generate(:base_regulation_sid) }
    f.measure_generating_regulation_role { 1 }
    f.additional_code_type_id { Forgery(:basic).text(exactly: 1) }
    f.goods_nomenclature_sid { generate(:goods_nomenclature_sid) }
    f.goods_nomenclature_item_id { 10.times.map{ Random.rand(9) }.join }
    f.geographical_area_sid { generate(:geographical_area_sid) }
    f.geographical_area_id { generate(:geographical_area_id) }
    f.validity_start_date { Date.today.ago(3.years) }
    f.validity_end_date   { nil }

    # mandatory valid associations
    f.goods_nomenclature { create :goods_nomenclature, validity_start_date: validity_start_date - 1.day,
                                                       goods_nomenclature_item_id: goods_nomenclature_item_id,
                                                       goods_nomenclature_sid: goods_nomenclature_sid,
                                                       producline_suffix: gono_producline_suffix,
                                                       indents: gono_number_indents }
    f.measure_type { create :measure_type, measure_type_id: measure_type_id,
                                   validity_start_date: validity_start_date - 1.day,
                                   measure_explosion_level: type_explosion_level,
                                   order_number_capture_code: order_number_capture_code }
    f.geographical_area {
      create(:geographical_area, geographical_area_sid: geographical_area_sid,
                                 geographical_area_id: geographical_area_id,
                                 validity_start_date: validity_start_date - 1.day)
    }
    f.base_regulation {
      create(:base_regulation, base_regulation_id: measure_generating_regulation_id,
                               base_regulation_role: measure_generating_regulation_role,
                               effective_end_date: Date.today.in(10.years))
    }

    trait :national do
      sequence(:measure_sid) { |n| -1 * n }
      national { true }
    end

    trait :invalidated do
      invalidated_at { Time.now }
    end

    trait :with_goods_nomenclature do
      # noop
    end

    trait :with_measure_type do
      # noop
    end

    trait :with_modification_regulation do
      measure_generating_regulation_role { 4 }

      after(:build) { |measure, evaluator|
        FactoryGirl.create(:modification_regulation, modification_regulation_id: measure.measure_generating_regulation_id)
      }
    end

    trait :with_abrogated_modification_regulation do
      measure_generating_regulation_role { 4 }

      after(:build) { |measure, evaluator|
        base_regulation = FactoryGirl.create(:base_regulation, :abrogated)
        FactoryGirl.create(:modification_regulation,
                            modification_regulation_id: measure.measure_generating_regulation_id,
                            modification_regulation_role: measure.measure_generating_regulation_role,
                            base_regulation_id: base_regulation.base_regulation_id,
                            base_regulation_role: base_regulation.base_regulation_role)
      }
    end

    trait :with_geographical_area do
      # noop
    end

    trait :with_additional_code_type do
      after(:build) { |measure, evaluator|
        FactoryGirl.create(:additional_code_type, additional_code_type_id: measure.additional_code_type_id )
      }
    end

    trait :with_related_additional_code_type do
      after(:build) { |measure, evaluator|
        FactoryGirl.create(:additional_code_type_measure_type, additional_code_type_id: measure.additional_code_type_id,
                                                               measure_type_id: measure.measure_type_id)
      }
    end

    trait :with_quota_order_number do
      after(:build) { |measure, evaluator|
        FactoryGirl.create(:quota_order_number, quota_order_number_id: measure.ordernumber)
      }
    end
  end

  factory :measure_type do
    transient do
      measure_type_description { Forgery(:basic).text }
    end

    measure_type_id        { generate(:measure_type_id) }
    measure_type_series_id { Forgery(:basic).text(exactly: 1) }
    validity_start_date    { Date.today.ago(3.years) }
    validity_end_date      { nil }
    measure_explosion_level { 10 }
    order_number_capture_code { 10 }

    trait :export do
      trade_movement_code { 1 }
    end

    trait :import do
      trade_movement_code { 0 }
    end

    trait :national do
      national { true }
    end

    trait :non_national do
      national { false }
    end

    trait :excise do
      measure_type_description "EXCISE 111"
    end

    after(:build) { |measure_type, evaluator|
      FactoryGirl.create(:measure_type_series, measure_type_series_id: measure_type.measure_type_series_id)
    }

    after(:build) { |measure_type, evaluator|
      FactoryGirl.create(
        :measure_type_description,
        measure_type_id: measure_type.measure_type_id,
        description: evaluator.measure_type_description
      )
    }
  end

  factory :measure_type_description do
    measure_type_id        { generate(:measure_type_id) }
    description { Forgery(:basic).text }
  end

  factory :measure_condition do
    measure_condition_sid { generate(:measure_condition_sid) }
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
