FactoryGirl.define do
  sequence(:code) {|n| Forgery(:basic).number(at_least: 100000000000, at_most: 999999999999) }

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
    ignore do
      chapter_number { Forgery(:basic).number(at_least: 10, at_most: 100).to_s }
    end

    nomenclature
    section
    description { Forgery(:basic).text }
    code        { generate :code }
    short_code  { chapter_number.first(2) }

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
    code        { generate :code }

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
    code        { generate :code }
  end

  factory :legal_act do
    code { "#{Forgery(:basic).text(exactly: 5)}/#{Forgery(:basic).text(exactly: 2)}" }
  end
end
