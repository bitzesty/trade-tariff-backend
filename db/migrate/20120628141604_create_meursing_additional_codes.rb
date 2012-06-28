class CreateMeursingAdditionalCodes < ActiveRecord::Migration
  def change
    create_table :meursing_additional_codes do |t|
      t.integer :meursing_additional_code_sid
      t.integer :additional_code
      t.date :validity_start_date

      t.timestamps
    end
  end
end
