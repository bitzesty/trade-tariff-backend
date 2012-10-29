FactoryGirl.define do
  factory :measure_type_series do
    measure_type_series_id { Forgery(:basic).text(exactly: 1) }
    validity_start_date     { Date.today.ago(2.years) }
    validity_end_date       { nil }
  end
end
