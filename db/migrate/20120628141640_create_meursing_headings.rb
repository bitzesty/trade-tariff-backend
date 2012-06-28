class CreateMeursingHeadings < ActiveRecord::Migration
  def change
    create_table :meursing_headings, :id => false do |t|
      t.string :meursing_table_plan_id
      t.integer :meursing_heading_number
      t.integer :row_column_code
      t.date :validity_start_date

      t.timestamps
    end
  end
end
