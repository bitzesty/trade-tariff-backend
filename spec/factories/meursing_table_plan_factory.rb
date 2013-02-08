FactoryGirl.define do
  factory :meursing_table_plan do
    meursing_table_plan_id          { Forgery(:basic).text(exactly: 2) }
    validity_start_date             { Date.today.ago(2.years) }
    validity_end_date               { nil }
  end
end
