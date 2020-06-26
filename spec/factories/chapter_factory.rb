FactoryBot.define do
  factory :chapter, parent: :goods_nomenclature, class: Chapter do
    goods_nomenclature_item_id { "#{2.times.map { Random.rand(9) }.join}00000000" }

    trait :with_section do
      after(:create) { |chapter, _evaluator|
        section = FactoryBot.create(:section)
        chapter.add_section section
        chapter.save
      }
    end

    trait :with_note do
      after(:create) { |chapter, _evaluator|
        FactoryBot.create(:chapter_note, chapter_id: chapter.to_param)
      }
    end

    trait :with_guide do
      after(:create) { |chapter, _evaluator|
        guide = FactoryBot.create(:chapter_guide)
        chapter.add_guide guide
        chapter.save
      }
    end
  end

  factory :chapter_note do
    chapter

    content { Forgery(:basic).text }
  end

  factory :chapter_guide, class: Guide do
    title { Forgery(:basic).text }
    url { Forgery(:basic).text }
  end
end
