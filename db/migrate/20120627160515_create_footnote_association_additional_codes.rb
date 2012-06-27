class CreateFootnoteAssociationAdditionalCodes < ActiveRecord::Migration
  def change
    create_table :footnote_association_additional_codes, :id => false do |t|
      t.string :additional_code_sid
      t.string :footnote_type_id
      t.string :footnote_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :additional_code_type_id
      t.string :additional_code

      t.timestamps
    end
  end
end
