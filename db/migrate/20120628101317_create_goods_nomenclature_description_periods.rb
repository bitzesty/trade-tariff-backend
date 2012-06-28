class CreateGoodsNomenclatureDescriptionPeriods < ActiveRecord::Migration
  def change
    create_table :goods_nomenclature_description_periods do |t|
      t.integer :goods_nomenclature_description_period_sid
      t.integer :goods_nomenclature_sid
      t.date :validity_start_date
      t.string :goods_nomenclature_item_id
      t.string :productline_suffix

      t.timestamps
    end
  end
end
