class CreateMeursingAdditionalCodes < ActiveRecord::Migration
  def change
    create_table :meursing_additional_codes, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :meursing_additional_code_sid
      t.integer :additional_code
      t.date :validity_start_date

      t.timestamps
    end
  end
end
