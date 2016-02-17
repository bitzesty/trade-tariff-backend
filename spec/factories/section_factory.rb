FactoryGirl.define do
  factory :section do
    position      { Forgery(:basic).number }
    numeral       { ["I", "II", "III"].sample }
    title         { Forgery(:basic).text }
    created_at    { Time.now }

    trait :with_note do
      after(:create) { |section, evaluator|
        FactoryGirl.create(:section_note, section_id: section.id)
      }
    end
  end

  factory :section_note do
    section

    content    {   Forgery(:basic).text }
  end
end
