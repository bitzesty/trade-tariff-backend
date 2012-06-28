class CreateGeographicalAreaDescriptionPeriods < ActiveRecord::Migration
  def change
    create_table :geographical_area_description_periods, :id => false do |t|
      t.integer :geographical_area_description_period_sid
      t.integer :geographical_area_sid
      t.date :validity_start_date
      t.string :geographical_area_id

      t.timestamps
    end
  end
end
