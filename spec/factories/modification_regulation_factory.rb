FactoryGirl.define do
  sequence(:modification_regulation_sid) { |n| n }

  factory :modification_regulation do
    modification_regulation_id   { generate(:sid) }
    modification_regulation_role { 4 }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end
end
