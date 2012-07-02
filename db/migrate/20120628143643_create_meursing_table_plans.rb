class CreateMeursingTablePlans < ActiveRecord::Migration
  def change
    create_table :meursing_table_plans, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      t.string :meursing_table_plan_id
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
