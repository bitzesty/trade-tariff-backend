class CreateGeographicalAreas < ActiveRecord::Migration
  def change
    create_table :geographical_areas do |t|
      t.integer :geographical_area_sid
      t.date :validity_start_date
      t.string :geographical_code
      t.string :geographical_area_id

      t.timestamps
    end
  end
end
