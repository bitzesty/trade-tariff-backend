class CreateFootnoteTypes < ActiveRecord::Migration
  def change
    create_table :footnote_types, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.string :footnote_type_id
      t.integer :application_code
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
