class CreateMeasurementUnitQualifiers < ActiveRecord::Migration
  def change
    create_table :measurement_unit_qualifiers, :id => false do |t|
      t.string :measurement_unit_qualifier_code
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
