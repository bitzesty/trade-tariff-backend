class CreateMeasureConditions < ActiveRecord::Migration
  def change
    create_table :measure_conditions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :measure_condition_sid
      t.integer :measure_sid
      t.string :condition_code
      t.integer :component_sequence_number
      t.integer :condition_duty_amount
      t.string :condition_monetary_unit_code
      t.string :condition_measurement_unit_code
      t.string :action_code
      t.string :certificate_type_code
      t.string :certificate_code
      t.timestamps
    end
  end
end
