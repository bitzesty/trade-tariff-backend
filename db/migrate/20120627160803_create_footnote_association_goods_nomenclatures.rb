class CreateFootnoteAssociationGoodsNomenclatures < ActiveRecord::Migration
  def change
    create_table :footnote_association_goods_nomenclatures, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      
      t.string :goods_nomenclature_sid
      t.string :footnote_type
      t.string :footnote_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.string :goods_nomenclature_item_id
      t.string :productline_suffix

      t.timestamps
    end
  end
end
