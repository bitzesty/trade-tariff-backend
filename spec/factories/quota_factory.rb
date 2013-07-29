FactoryGirl.define do
  sequence(:quota_order_number_sid) { |n| n}

  factory :quota_order_number do
    quota_order_number_sid { generate(:quota_order_number_sid) }
    quota_order_number_id  { 6.times.map{ Random.rand(9) }.join }
    validity_start_date { Date.today.ago(4.years) }
    validity_end_date   { nil }
  end

  factory :quota_definition do
    quota_definition_sid   { generate(:quota_order_number_sid) }
    quota_order_number_sid { generate(:quota_order_number_sid) }
    quota_order_number_id  { 6.times.map{ Random.rand(9) }.join }

    trait :actual do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { nil }
    end
  end

  factory :quota_balance_event do
    quota_definition
    last_import_date_in_allocation { Time.now }
    old_balance { Forgery(:basic).number }
    new_balance { Forgery(:basic).number }
    imported_amount { Forgery(:basic).number }
    occurrence_timestamp { Time.now }
  end

  factory :quota_exhaustion_event do
    quota_definition
    exhaustion_date { Date.today }
    occurrence_timestamp { Time.now }
  end

  factory :quota_critical_event do
    quota_definition
    critical_state_change_date { Date.today }
    occurrence_timestamp { Time.now }
  end

end
