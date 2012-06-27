class CreateExportRefundNomenclatureIndents < ActiveRecord::Migration
  def change
    create_table :export_refund_nomenclature_indents, :id => false do |t|
      t.string :export_refund_nomenclature_indents_sid
      t.string :export_refund_nomenclature_sid
      t.date :validity_start_date
      t.string :number_export_refund_nomenclature_indents
      t.string :goods_nomenclature_item_id
      t.integer :additional_code_type
      t.string :export_refund_code
      t.string :productline_suffix

      t.timestamps
    end
  end
end
