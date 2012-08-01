FactoryGirl.define do
  sequence(:sid) { |n| n}

  factory :goods_nomenclature do
    ignore do
      indents { 1 }
    end

    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_item_id { 10.times.map{ Random.rand(9) }.join }
    producline_suffix   { [10,20,80].sample }
    validity_start_date { Date.today.ago(2.years) }
    validity_end_date   { nil }

    trait :actual do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { nil }
    end

    trait :expired do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { Date.today.ago(1.year)  }
    end

    trait :with_indent do
      after(:create) { |gono, evaluator|
        FactoryGirl.create(:goods_nomenclature_indent, goods_nomenclature_sid: gono.goods_nomenclature_sid,
                                                       number_indents: evaluator.indents)
      }
    end
  end

  factory :commodity, parent: :goods_nomenclature, class: Commodity do
  end

  factory :chapter, parent: :goods_nomenclature, class: Chapter do
    goods_nomenclature_item_id { "#{2.times.map{ Random.rand(9) }.join}00000000" }
  end

  factory :heading, parent: :goods_nomenclature, class: Heading do
    goods_nomenclature_item_id { "#{4.times.map{ Random.rand(9) }.join}000000" }
  end

  factory :goods_nomenclature_indent do
    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_indent_sid { generate(:sid) }
    number_indents { Forgery(:basic).number }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :quota_definition do
    quota_definition_sid   { generate(:sid) }
    quota_order_number_sid { generate(:sid) }
    quota_order_number_id  { 6.times.map{ Random.rand(9) }.join }

    trait :actual do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { nil }
    end
  end

  factory :quota_balance_event do
    quota_definition
    last_import_date_in_allocation { Time.now }
    old_balance { Forgery(:basic).number }
    new_balance { Forgery(:basic).number }
    imported_amount { Forgery(:basic).number }
    occurrence_timestamp { Time.now }
  end

  factory :quota_exhaustion_event do
    quota_definition
    exhaustion_date { Date.today }
    occurrence_timestamp { Time.now }
  end

  factory :quota_critical_event do
    quota_definition
    critical_state_change_date { Date.today }
    occurrence_timestamp { Time.now }
  end

  factory :section do
    position { Forgery(:basic).number }
    numeral { ["I", "II", "III"].sample }
    title { Forgery(:lorem_ipsum).sentence }
  end
end
