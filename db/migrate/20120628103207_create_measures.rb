class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :measure_sid
      t.integer :measure_type
      t.string :geographical_area
      t.string :goods_nomenclature_item_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :measure_generating_regulation_role
      t.string :measure_generating_regulation_id
      t.integer :justification_regulation_role
      t.string :justification_regulation_id
      t.boolean :stopped_flag
      t.integer :geographical_area_sid
      t.integer :goods_nomenclature_sid
      t.string :ordernumber
      t.integer :additional_code_type
      t.string :additional_code
      t.string :additional_code_sid
      t.integer :reduction_indicator
      t.string :export_refund_nomenclature_sid

      t.timestamps
    end
  end
end
