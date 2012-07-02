class CreateGoodsNomenclatureGroupDescriptions < ActiveRecord::Migration
  def change
    create_table :goods_nomenclature_group_descriptions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.string :goods_nomenclature_group_type
      t.string :goods_nomenclature_group_id
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
