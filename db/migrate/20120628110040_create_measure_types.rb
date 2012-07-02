class CreateMeasureTypes < ActiveRecord::Migration
  def change
    create_table :measure_types, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :measure_type_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :trade_movement_code
      t.integer :priority_code
      t.integer :measure_component_applicable_code
      t.integer :origin_dest_code
      t.integer :order_number_capture_code
      t.integer :measure_explosion_level
      t.string :measure_type_series_id

      t.timestamps
    end
  end
end
