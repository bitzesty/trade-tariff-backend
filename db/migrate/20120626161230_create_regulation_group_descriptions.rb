class CreateRegulationGroupDescriptions < ActiveRecord::Migration
  def change
    create_table :regulation_group_descriptions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      
      t.string :regulation_group_id
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
