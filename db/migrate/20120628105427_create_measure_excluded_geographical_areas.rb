class CreateMeasureExcludedGeographicalAreas < ActiveRecord::Migration
  def change
    create_table :measure_excluded_geographical_areas, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :measure_sid
      t.string :excluded_geographical_area
      t.integer :geographical_area_sid

      t.timestamps
    end
  end
end
