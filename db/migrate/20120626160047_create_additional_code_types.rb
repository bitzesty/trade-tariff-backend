class CreateAdditionalCodeTypes < ActiveRecord::Migration
  def change
    create_table :additional_code_types, :id => false do |t|
      t.string :id
      t.date :validity_start_date
      t.date :validity_end_date
      t.string :code
      t.string :meursing_table_plan_id

      t.timestamps
    end
  end
end
