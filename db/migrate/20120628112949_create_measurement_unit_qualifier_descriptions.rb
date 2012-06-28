class CreateMeasurementUnitQualifierDescriptions < ActiveRecord::Migration
  def change
    create_table :measurement_unit_qualifier_descriptions, :id => false do |t|
      t.string :measurement_unit_qualifier_code
      t.string :language_id
      t.string :description

      t.timestamps
    end
  end
end
