class CreateGoodsNomenclatureIndents < ActiveRecord::Migration
  def change
    create_table :goods_nomenclature_indents, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :goods_nomenclature_indent_sid
      t.integer :goods_nomenclature_sid
      t.date :validity_start_date
      t.string :number_indents
      t.string :goods_nomenclature_item_id
      t.string :productline_suffix

      t.timestamps
    end
  end
end
