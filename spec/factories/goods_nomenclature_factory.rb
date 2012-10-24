FactoryGirl.define do
  sequence(:goods_nomenclature_sid) { |n| n}

  factory :goods_nomenclature do
    ignore do
      indents { 1 }
      description { Forgery(:basic).text }
    end

    goods_nomenclature_sid { generate(:goods_nomenclature_sid) }
    goods_nomenclature_item_id { 10.times.map{ Random.rand(9) }.join }
    producline_suffix   { [10,20,80].sample }
    validity_start_date { Date.today.ago(2.years) }
    validity_end_date   { nil }

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
      after(:create) { |gono, evaluator|
        FactoryGirl.create(:goods_nomenclature_indent, goods_nomenclature_sid: gono.goods_nomenclature_sid,
                                                       number_indents: evaluator.indents)
      }
    end

    trait :with_description do
      after(:create) { |gono, evaluator|
        FactoryGirl.create(:goods_nomenclature_description, goods_nomenclature_sid: gono.goods_nomenclature_sid,
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
  end

  factory :chapter, parent: :goods_nomenclature, class: Chapter do
    goods_nomenclature_item_id { "#{2.times.map{ Random.rand(9) }.join}00000000" }

    trait :with_section do
      after(:create) { |chapter, evaluator|
        section = FactoryGirl.create(:section)
        chapter.add_section section
      }
    end

    trait :with_note do
      after(:create) { |chapter, evaluator|
        FactoryGirl.create(:chapter_note, chapter_id: chapter.goods_nomenclature_sid)
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
    ignore do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date { nil }
      valid_at Time.now.ago(2.years)
      valid_to nil
    end

    goods_nomenclature_sid { generate(:sid) }
    description { Forgery(:basic).text }
    goods_nomenclature_description_period_sid { generate(:sid) }

    after(:create) { |gono_description, evaluator|
      FactoryGirl.create(:goods_nomenclature_description_period, goods_nomenclature_description_period_sid: gono_description.goods_nomenclature_description_period_sid,
                                                              goods_nomenclature_sid: gono_description.goods_nomenclature_sid,
                                                              goods_nomenclature_item_id: gono_description.goods_nomenclature_item_id,
                                                              validity_start_date: evaluator.valid_at,
                                                              validity_end_date: evaluator.valid_to)
    }
  end

  factory :section do
    position { Forgery(:basic).number }
    numeral { ["I", "II", "III"].sample }
    title { Forgery(:lorem_ipsum).sentence }
  end
end
