class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.string :measurement_unit_code
      t.string :measurement_unit_qualifier_code
      t.date :validity_start_date

      t.timestamps
    end
  end
end
