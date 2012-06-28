class CreateMonetaryUnits < ActiveRecord::Migration
  def change
    create_table :monetary_units, :id => false do |t|
      t.string :monetary_unit_code
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
