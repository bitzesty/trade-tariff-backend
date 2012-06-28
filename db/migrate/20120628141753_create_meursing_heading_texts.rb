class CreateMeursingHeadingTexts < ActiveRecord::Migration
  def change
    create_table :meursing_heading_texts, :id => false do |t|
      t.string :meursing_table_plan_id
      t.integer :meursing_heading_number
      t.integer :row_column_code
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
