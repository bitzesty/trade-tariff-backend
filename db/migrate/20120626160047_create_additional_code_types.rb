class CreateAdditionalCodeTypes < ActiveRecord::Migration
  def change
    create_table :additional_code_types do |t|
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :code
      t.integer :meursing_table_plan_id

      t.timestamps
    end
  end
end
