FactoryGirl.define do
  sequence(:export_refund_nomenclature_sid) { |n| n }

  factory :export_refund_nomenclature do
    transient do
      indents { 1 }
    end

    export_refund_nomenclature_sid { generate(:export_refund_nomenclature_sid) }
    goods_nomenclature_item_id { 10.times.map{ Random.rand(9) }.join }
    export_refund_code   { 3.times.map{ Random.rand(9) }.join }
    additional_code_type { Random.rand(9) }
    productline_suffix   { [10,20,80].sample }
    validity_start_date  { Date.today.ago(2.years) }
    validity_end_date    { nil }

    trait :with_indent do
      after(:create) { |gono, evaluator|
        FactoryGirl.create(:export_refund_nomenclature_indent, export_refund_nomenclature_sid: gono.export_refund_nomenclature_sid,
                                                               number_export_refund_nomenclature_indents: evaluator.indents)
      }
    end
  end

  factory :export_refund_nomenclature_indent do
    export_refund_nomenclature_sid { generate(:export_refund_nomenclature_sid) }
    export_refund_nomenclature_indents_sid { generate(:export_refund_nomenclature_sid) }
    number_export_refund_nomenclature_indents { Forgery(:basic).number }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :export_refund_nomenclature_description_period do
    export_refund_nomenclature_sid { generate(:sid) }
    export_refund_nomenclature_description_period_sid { generate(:sid) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :export_refund_nomenclature_description do
    transient do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date { nil }
      valid_at Time.now.ago(2.years)
      valid_to nil
    end

    export_refund_nomenclature_sid { generate(:sid) }
    description { Forgery(:basic).text }
    export_refund_nomenclature_description_period_sid { generate(:sid) }

    after(:create) { |gono_description, evaluator|
      FactoryGirl.create(:export_refund_nomenclature_description_period, export_refund_nomenclature_description_period_sid: gono_description.export_refund_nomenclature_description_period_sid,
                                                              export_refund_nomenclature_sid: gono_description.export_refund_nomenclature_sid,
                                                              goods_nomenclature_item_id: gono_description.goods_nomenclature_item_id,
                                                              validity_start_date: evaluator.valid_at,
                                                              validity_end_date: evaluator.valid_to)
    }
  end
end
