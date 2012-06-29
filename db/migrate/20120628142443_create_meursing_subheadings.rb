class CreateMeursingSubheadings < ActiveRecord::Migration
  def change
    create_table :meursing_subheadings, :id => false do |t|
      t.string :meursing_table_plan_id
      t.integer :meursing_heading_number
      t.integer :row_column_code
      t.integer :subheading_sequence_number
      t.date :validity_start_date
      t.date :validity_end_date
      t.text :description

      t.timestamps
    end
  end
end
