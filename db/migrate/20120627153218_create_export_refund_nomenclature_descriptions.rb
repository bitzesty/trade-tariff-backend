class CreateExportRefundNomenclatureDescriptions < ActiveRecord::Migration
  def change
    create_table :export_refund_nomenclature_descriptions, :id => false do |t|
      t.string :export_refund_nomenclature_description_period_sid
      t.string :language_id
      t.string :export_refund_nomenclature_sid
      t.string :goods_nomenclature_item_id
      t.integer :additional_code_type
      t.string :export_refund_code
      t.string :productline_suffix
      t.text :description

      t.timestamps
    end
  end
end
