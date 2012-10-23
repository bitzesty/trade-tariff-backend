FactoryGirl.define do
  factory :measurement_unit_qualifier do
    measurement_unit_qualifier_code { Forgery(:basic).text(exactly: 1)}
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end
end
