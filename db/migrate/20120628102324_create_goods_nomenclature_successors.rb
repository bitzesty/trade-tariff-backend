class CreateGoodsNomenclatureSuccessors < ActiveRecord::Migration
  def change
    create_table :goods_nomenclature_successors, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :goods_nomenclature_sid
      t.string :absorbed_goods_nomenclature_item_id
      t.string :absorbed_productline_suffix
      t.string :goods_nomenclature_item_id
      t.string :productline_suffix

      t.timestamps
    end
  end
end
