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
    quota_order_number_id  { generate(:quota_order_number_id) }
    monetary_unit_code              { Forgery(:basic).text(exactly: 3) }
    measurement_unit_code           { Forgery(:basic).text(exactly: 3) }
    measurement_unit_qualifier_code { generate(:measurement_unit_qualifier_code) }

    trait :actual do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { nil }
    end

   trait :xml do
      validity_start_date              { Date.today.ago(3.years) }
      validity_end_date                { Date.today.ago(1.years) }
      volume                           { Forgery(:basic).number }
      initial_volume                   { Forgery(:basic).number }
      measurement_unit_code            { Forgery(:basic).text(exactly: 2) }
      maximum_precision                { Forgery(:basic).number }
      critical_state                   { Forgery(:basic).text(exactly: 2) }
      critical_threshold               { Forgery(:basic).number }
      monetary_unit_code               { Forgery(:basic).text(exactly: 2) }
      measurement_unit_qualifier_code { generate(:measurement_unit_qualifier_code) }
      description                      { Forgery(:lorem_ipsum).sentence }
    end
  end

  factory :quota_blocking_period do
    quota_blocking_period_sid  { Forgery(:basic).number }
    quota_definition_sid       { Forgery(:basic).number }
    blocking_start_date        { Date.today.ago(1.years) }
    blocking_end_date          { Date.today.ago(1.years) }
    blocking_period_type       { Forgery(:basic).number }
    description                { Forgery(:lorem_ipsum).sentence }
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
