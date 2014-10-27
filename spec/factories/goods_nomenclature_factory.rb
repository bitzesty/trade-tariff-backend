FactoryGirl.define do
  sequence(:goods_nomenclature_sid) { |n| n}

  factory :goods_nomenclature do
    transient do
      indents { 1 }
      description { Forgery(:basic).text }
    end

    goods_nomenclature_sid { generate(:goods_nomenclature_sid) }
    # do not allow zeroes in the goods item id as it causes unpredictable
    # results
    goods_nomenclature_item_id { 10.times.map{ Random.rand(9) + 1 }.join }
    producline_suffix   { 80 }
    validity_start_date { Date.today.ago(2.years) }
    validity_end_date   { nil }

    after(:build) { |gono, evaluator|
      FactoryGirl.create(:goods_nomenclature_indent, goods_nomenclature_sid: gono.goods_nomenclature_sid,
                                                     validity_start_date: gono.validity_start_date,
                                                     validity_end_date: gono.validity_end_date,
                                                     number_indents: evaluator.indents)
    }

    trait :actual do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { nil }
    end

    trait :fifteen_years do
      validity_start_date { Date.today.ago(15.years) }
    end

    trait :declarable do
      producline_suffix 80
    end

    trait :expired do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { Date.today.ago(1.year)  }
    end

    trait :with_indent do
      # noop
    end

    trait :with_description do
      before(:create) { |gono, evaluator|
        FactoryGirl.create(:goods_nomenclature_description, goods_nomenclature_sid: gono.goods_nomenclature_sid,
                                                            goods_nomenclature_item_id: gono.goods_nomenclature_item_id,
                                                            validity_start_date: gono.validity_start_date,
                                                            validity_end_date: gono.validity_end_date,
                                                            description: evaluator.description)
      }
    end
  end

  factory :commodity, parent: :goods_nomenclature, class: Commodity do
    trait :declarable do
      producline_suffix { 80 }
    end

    trait :non_declarable do
      producline_suffix { 10 }
    end

    trait :with_chapter do
      after(:create) { |commodity, evaluator|
        FactoryGirl.create(:chapter, :with_section, goods_nomenclature_item_id: "#{commodity.chapter_id}")
      }
    end

    trait :with_heading do
      after(:create) { |commodity, evaluator|
        FactoryGirl.create(:heading, goods_nomenclature_item_id: "#{commodity.goods_nomenclature_item_id.first(4)}000000")
      }
    end
  end

  factory :heading, parent: :goods_nomenclature, class: Heading do
    # +1 is needed to avoid creating heading with gono id in form of
    # xx00xxxxxx which is a Chapter
    goods_nomenclature_item_id { "#{4.times.map{ Random.rand(8)+1 }.join}000000" }

    trait :declarable do
      producline_suffix { 80 }
    end

    trait :non_grouping do
      producline_suffix { 80 }
    end

    trait :non_declarable do
      after(:create) { |heading, evaluator|
        FactoryGirl.create(:goods_nomenclature, :with_description,
                                                :with_indent,
                                                goods_nomenclature_item_id: "#{heading.short_code}#{6.times.map{ Random.rand(9) }.join}")
      }
    end

    trait :with_chapter do
      after(:create) { |heading, evaluator|
        FactoryGirl.create(:goods_nomenclature, :with_description,
                                                :with_indent,
                                                goods_nomenclature_item_id: heading.chapter_id)
      }
    end
  end

  factory :goods_nomenclature_indent do
    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_indent_sid { generate(:sid) }
    number_indents { Forgery(:basic).number }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :goods_nomenclature_description_period do
    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_description_period_sid { generate(:sid) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :goods_nomenclature_description do
    transient do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date { nil }
    end

    goods_nomenclature_sid { generate(:sid) }
    description { Forgery(:basic).text }
    goods_nomenclature_description_period_sid { generate(:sid) }

    before(:create) { |gono_description, evaluator|
      FactoryGirl.create(:goods_nomenclature_description_period, goods_nomenclature_description_period_sid: gono_description.goods_nomenclature_description_period_sid,
                                                              goods_nomenclature_sid: gono_description.goods_nomenclature_sid,
                                                              goods_nomenclature_item_id: gono_description.goods_nomenclature_item_id,
                                                              validity_start_date: evaluator.validity_start_date,
                                                              validity_end_date: evaluator.validity_end_date)
    }
  end
end
