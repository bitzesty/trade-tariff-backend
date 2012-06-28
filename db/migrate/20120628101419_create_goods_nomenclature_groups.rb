class CreateGoodsNomenclatureGroups < ActiveRecord::Migration
  def change
    create_table :goods_nomenclature_groups do |t|
      t.string :goods_nomenclature_group_type
      t.string :goods_nomenclature_group_id
      t.date :validity_start_date
      t.integer :nomenclature_group_facility_code

      t.timestamps
    end
  end
end
