class CreateMeursingTableCellComponents < ActiveRecord::Migration
  def change
    create_table :meursing_table_cell_components, :id => false do |t|
      t.integer :meursing_additional_code_sid
      t.string :meursing_table_plan_id
      t.integer :heading_number
      t.integer :row_column_code
      t.integer :subheading_sequence_number
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :additional_code

      t.timestamps
    end
  end
end
