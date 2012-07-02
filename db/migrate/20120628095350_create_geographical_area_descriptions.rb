class CreateGeographicalAreaDescriptions < ActiveRecord::Migration
  def change
    create_table :geographical_area_descriptions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      
      t.integer :geographical_area_description_period_sid
      t.string :language_id
      t.integer :geographical_area_sid
      t.string :geographical_area_id
      t.text :description

      t.timestamps
    end
  end
end
