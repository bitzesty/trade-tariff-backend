FactoryGirl.define do
  sequence(:complete_abrogation_regulation_sid) { |n| n }

  factory :complete_abrogation_regulation do
    complete_abrogation_regulation_id   { generate(:sid) }
    complete_abrogation_regulation_role { Forgery(:basic).number }
  end
end
