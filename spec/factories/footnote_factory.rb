FactoryGirl.define do
  sequence(:footnote_sid) { |n| n}

  factory :footnote do
    ignore do
      valid_at Time.now.ago(2.years)
      valid_to nil
      goods_nomenclature_sid { generate(:goods_nomenclature_sid) }
    end

    footnote_id      { Forgery(:basic).text(exactly: 3) }
    footnote_type_id { Forgery(:basic).text(exactly: 2) }
    validity_start_date     { Date.today.ago(2.years) }
    validity_end_date       { nil }

    trait :with_gono_association do
      after(:create) { |ftn, evaluator|
        FactoryGirl.create(:footnote_association_goods_nomenclature, goods_nomenclature_sid: evaluator.goods_nomenclature_sid,
                                                                     footnote_id: ftn.footnote_id,
                                                                     footnote_type: ftn.footnote_type_id,
                                                                     validity_start_date: evaluator.valid_at,
                                                                     validity_end_date: evaluator.valid_to)
      }
    end
  end

  factory :footnote_description_period do
    footnote_description_period_sid { generate(:footnote_sid) }
    footnote_id      { Forgery(:basic).text(exactly: 3) }
    footnote_type_id { Forgery(:basic).text(exactly: 2) }
    validity_start_date                    { Date.today.ago(2.years) }
    validity_end_date                      { nil }
  end

  factory :footnote_description do
    ignore do
      valid_at Time.now.ago(2.years)
      valid_to nil
    end

    footnote_description_period_sid { generate(:footnote_sid) }
    footnote_id                     { Forgery(:basic).text(exactly: 3) }
    footnote_type_id                { Forgery(:basic).text(exactly: 2) }
    description                     { Forgery(:lorem_ipsum).sentence }

    trait :with_period do
      after(:create) { |ftn_description, evaluator|
        FactoryGirl.create(:footnote_description_period, footnote_description_period_sid: ftn_description.footnote_description_period_sid,
                                                                footnote_id: ftn_description.footnote_id,
                                                                footnote_type_id: ftn_description.footnote_type_id,
                                                                validity_start_date: evaluator.valid_at,
                                                                validity_end_date: evaluator.valid_to)
      }
    end
  end

  factory :footnote_association_goods_nomenclature do
    goods_nomenclature_sid          { generate(:goods_nomenclature_sid) }
    footnote_id                     { Forgery(:basic).text(exactly: 3) }
    footnote_type                   { Forgery(:basic).text(exactly: 2) }
    validity_start_date             { Date.today.ago(2.years) }
    validity_end_date               { nil }
  end

  factory :footnote_association_measure do
    measure_sid                     { generate(:measure_sid) }
    footnote_id                     { Forgery(:basic).text(exactly: 3) }
    footnote_type_id                { Forgery(:basic).text(exactly: 2) }
  end
end
