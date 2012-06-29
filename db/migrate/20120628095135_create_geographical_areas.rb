class CreateGeographicalAreas < ActiveRecord::Migration
  def change
    create_table :geographical_areas, :id => false do |t|
      t.integer :geographical_area_sid
      t.integer :parent_geographical_area_group_sid
      t.date :validity_start_date
      t.date :validity_end_date
      t.string :geographical_code
      t.string :geographical_area_id

      t.timestamps
    end
  end
end
