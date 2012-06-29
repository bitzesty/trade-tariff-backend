class CreateMeursingTablePlans < ActiveRecord::Migration
  def change
    create_table :meursing_table_plans, :id => false do |t|
      t.string :meursing_table_plan_id
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
