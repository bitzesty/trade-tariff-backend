class CreateFootnoteAssociationMeasures < ActiveRecord::Migration
  def change
    create_table :footnote_association_measures, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      
      t.string :measure_sid
      t.string :footnote_type_id
      t.string :footnote_id

      t.timestamps
    end
  end
end
