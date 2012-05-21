FactoryGirl.define do

  factory :nomenclature do
    as_of_date { Date.today }
  end

  factory :section do
    nomenclature
    title    { Forgery(:basic).text }
    position { Forgery(:basic).number }

    trait :with_chapters do
      after(:create) do |section, evaluator|
        # FactoryGirl.create_list(:chapter, section: section)
      end
    end
  end

  factory :chapter do
    nomenclature
    section
    description { Forgery(:basic).text }
    code        { Forgery(:basic).number }
  end

  factory :heading do
    nomenclature
    chapter
    description { Forgery(:basic).text }
  end

  factory :commodity do
    nomenclature
    heading
    description { Forgery(:basic).text }
  end
end
