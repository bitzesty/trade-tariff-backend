class CreateGoodsNomenclatureOrigins < ActiveRecord::Migration
  def change
    create_table :goods_nomenclature_origins, :id => false do |t|
      t.integer :goods_nomenclature_sid
      t.string :derived_goods_nomenclature_item_id
      t.string :derived_productline_suffix
      t.string :goods_nomenclature_item_id
      t.string :productline_suffix

      t.timestamps
    end
  end
end
