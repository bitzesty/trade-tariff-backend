class CreateMeasurementUnitDescriptions < ActiveRecord::Migration
  def change
    create_table :measurement_unit_descriptions, :id => false do |t|
      t.string :measurement_unit_code
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
