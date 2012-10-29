FactoryGirl.define do
  factory :regulation_group do
    regulation_group_id     { Forgery(:basic).text(exactly: 3) }
    validity_start_date     { Date.today.ago(2.years) }
    validity_end_date       { nil }
  end
end
