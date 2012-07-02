class CreateMeasurementUnits < ActiveRecord::Migration
  def change
    create_table :measurement_units, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.string :measurement_unit_code
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
