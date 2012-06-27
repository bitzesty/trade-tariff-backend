class CreateFootnoteAssociationMeasures < ActiveRecord::Migration
  def change
    create_table :footnote_association_measures, :id => false do |t|
      t.string :measure_sid
      t.string :footnote_type_id
      t.string :footnote_id

      t.timestamps
    end
  end
end
