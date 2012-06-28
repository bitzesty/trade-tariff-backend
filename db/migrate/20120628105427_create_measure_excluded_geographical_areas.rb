class CreateMeasureExcludedGeographicalAreas < ActiveRecord::Migration
  def change
    create_table :measure_excluded_geographical_areas, :id => false do |t|
      t.integer :measure_sid
      t.string :excluded_geographical_area
      t.integer :geographical_area_sid

      t.timestamps
    end
  end
end
