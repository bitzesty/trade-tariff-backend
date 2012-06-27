class CreateFootnoteAssociationMeursingHeadings < ActiveRecord::Migration
  def change
    create_table :footnote_association_meursing_headings, :id => false do |t|
      t.string :meursing_table_plan_id
      t.string :meursing_heading_number
      t.integer :row_column_code
      t.string :footnote_type
      t.string :footnote_id
      t.date :validity_start_date

      t.timestamps
    end
  end
end
