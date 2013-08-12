FactoryGirl.define do
  factory :chapter, parent: :goods_nomenclature, class: Chapter do
    goods_nomenclature_item_id { "#{2.times.map{ Random.rand(9) }.join}00000000" }

    trait :with_section do
      after(:create) { |chapter, evaluator|
        section = FactoryGirl.create(:section)
        chapter.add_section section
        chapter.save
      }
    end

    trait :with_note do
      after(:create) { |chapter, evaluator|
        FactoryGirl.create(:chapter_note, chapter_id: chapter.to_param)
      }
    end
  end

  factory :chapter_note do
    chapter

    content    {   Forgery(:basic).text }
  end
end
