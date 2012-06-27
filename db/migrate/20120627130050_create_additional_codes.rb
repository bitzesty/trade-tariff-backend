class CreateAdditionalCodes < ActiveRecord::Migration
  def change
    create_table :additional_codes, :id => false do |t|
      t.string :additional_code_sid
      t.string :additional_code_type_id
      t.string :additional_code
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
