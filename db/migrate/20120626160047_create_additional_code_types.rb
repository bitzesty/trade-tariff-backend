class CreateAdditionalCodeTypes < ActiveRecord::Migration
  def change
    create_table :additional_code_types, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      
      t.string :additional_code_type_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.string :application_code
      t.string :meursing_table_plan_id
      
      t.timestamps
    end
  end
end
