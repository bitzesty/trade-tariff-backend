class CreateMeasureTypeDescriptions < ActiveRecord::Migration
  def change
    create_table :measure_type_descriptions, :id => false do |t|
      t.integer :measure_type_id
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
