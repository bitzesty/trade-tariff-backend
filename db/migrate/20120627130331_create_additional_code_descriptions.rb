class CreateAdditionalCodeDescriptions < ActiveRecord::Migration
  def change
    create_table :additional_code_descriptions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      
      t.string :additional_code_description_period_sid
      t.string :language_id
      t.string :additional_code_sid
      t.string :additional_code_type_id
      t.string :additional_code
      t.text :description

      t.timestamps
    end
  end
end
