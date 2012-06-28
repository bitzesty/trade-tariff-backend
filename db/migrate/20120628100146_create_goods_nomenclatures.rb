class CreateGoodsNomenclatures < ActiveRecord::Migration
  def change
    create_table :goods_nomenclatures do |t|
      t.integer :goods_nomenclature_sid
      t.string :goods_nomenclature_item_id
      t.string :producline_suffix
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :statistical_indicator

      t.timestamps
    end
  end
end
