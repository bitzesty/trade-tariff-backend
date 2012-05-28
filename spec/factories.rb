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

    factory :chapter_with_headings do
      after(:create) do |chapter|
        create_list(:heading, 3, chapter: chapter)
      end
    end
  end

  factory :heading do
    nomenclature
    chapter
    description { Forgery(:basic).text }

    factory :heading_with_commodities do
      after(:create) do |heading|
        create_list(:commodity, 3, heading: heading)
      end
    end
  end

  factory :commodity do
    nomenclature
    heading
    description { Forgery(:basic).text }
  end

  factory :legal_act do
    code { "#{Forgery(:basic).text(exactly: 5)}/#{Forgery(:basic).text(exactly: 2)}" }
  end
end
