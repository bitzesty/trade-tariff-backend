FactoryGirl.define do
  factory :section do
    position      { Forgery(:basic).number }
    numeral       { %w[I II III].sample }
    title         { Forgery(:basic).text }
    created_at    { Time.now }
    updated_at    { Time.now }

    trait :with_note do
      after(:create) { |section, _evaluator|
        FactoryGirl.create(:section_note, section_id: section.id)
      }
    end
  end

  factory :section_note do
    section

    content { Forgery(:basic).text }
  end
end
