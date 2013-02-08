FactoryGirl.define do
  factory :meursing_heading do
    meursing_table_plan_id          { Forgery(:basic).text(exactly: 2) }
    meursing_heading_number         { Forgery(:basic).number }
    row_column_code                 { Forgery(:basic).number }
    validity_start_date             { Date.today.ago(2.years) }
    validity_end_date               { nil }
  end
end
