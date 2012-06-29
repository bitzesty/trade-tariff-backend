class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements, :id => false do |t|
      t.string :measurement_unit_code
      t.string :measurement_unit_qualifier_code
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
