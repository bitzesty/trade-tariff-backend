class CreateGoodsNomenclatureGroupDescriptions < ActiveRecord::Migration
  def change
    create_table :goods_nomenclature_group_descriptions, :id => false do |t|
      t.string :goods_nomenclature_group_type
      t.string :goods_nomenclature_group_id
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
