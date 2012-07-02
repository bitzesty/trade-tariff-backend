class CreateRegulationReplacements < ActiveRecord::Migration
  def change
    create_table :regulation_replacements, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.string :geographical_area_id
      t.string :chapter_heading
      t.integer :replacing_regulation_role
      t.string :replacing_regulation_id
      t.integer :replaced_regulation_role
      t.string :replaced_regulation_id
      t.integer :measure_type_id

      t.timestamps
    end
  end
end
