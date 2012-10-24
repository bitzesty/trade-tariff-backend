FactoryGirl.define do
  factory :base_regulation do
    base_regulation_id { generate(:sid) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end
end
