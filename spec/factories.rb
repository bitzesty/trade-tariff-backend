FactoryGirl.define do

  factory :nomenclature do
    as_of_date { Date.today }
  end

  factory :section do
    nomenclature
    title    { Forgery(:basic).text }
    position { Forgery(:basic).number }

    factory :section_with_chapters do
      after(:create) do |section|
        create_list(:chapter, 3, section: section)
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
