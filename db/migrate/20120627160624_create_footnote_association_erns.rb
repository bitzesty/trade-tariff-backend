class CreateFootnoteAssociationErns < ActiveRecord::Migration
  def change
    create_table :footnote_association_erns do |t|
      t.string :export_refund_nomenclature_sid
      t.string :footnote_type
      t.string :footnote_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.string :goods_nomenclature_item_id
      t.integer :additional_code_type
      t.string :export_refund_code
      t.string :productline_suffix

      t.timestamps
    end
  end
end
