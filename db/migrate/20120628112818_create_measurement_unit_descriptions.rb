class CreateMeasurementUnitDescriptions < ActiveRecord::Migration
  def change
    create_table :measurement_unit_descriptions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.string :measurement_unit_code
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
