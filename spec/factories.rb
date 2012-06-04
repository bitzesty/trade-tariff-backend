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

    factory :commodity_with_children do
      after(:create) do |commodity|
        create_list(:commodity, 1, parent: commodity)
      end
    end
  end

  factory :legal_act do
    code { "#{Forgery(:basic).text(exactly: 5)}/#{Forgery(:basic).text(exactly: 2)}" }
  end

  factory :country do
    name { Forgery(:address).country }
    iso_code { Forgery(:address).country.first(2).upcase } # take a guess, not necessarily correct
  end

  factory :measure do
    export { [true, false].sample }
    origin { ["EU", "UK"].sample }
    measure_type { Forgery(:basic).text }
    duty_rates { Forgery(:basic).text }

    trait :with_region do
      association :region, factory: :country
    end

    trait :export do
      export { true }
    end

    trait :import do
      export { false }
    end
  end
end
