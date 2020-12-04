FactoryBot.define do
  factory :measure_action do
    action_code         { Forgery(:basic).text(exactly: 2) }
    validity_start_date { Date.current.ago(3.years) }
    validity_end_date   { nil }
  end
end
