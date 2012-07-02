class CreateFootnotes < ActiveRecord::Migration
  def change
    create_table :footnotes, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      
      t.string :footnote_id
      t.string :footnote_type_id
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
