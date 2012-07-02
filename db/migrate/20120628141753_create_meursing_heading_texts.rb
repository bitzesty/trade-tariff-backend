class CreateMeursingHeadingTexts < ActiveRecord::Migration
  def change
    create_table :meursing_heading_texts, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.string :meursing_table_plan_id
      t.integer :meursing_heading_number
      t.integer :row_column_code
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
