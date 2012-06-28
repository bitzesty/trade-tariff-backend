class CreateMeasureConditionCodes < ActiveRecord::Migration
  def change
    create_table :measure_condition_codes, :id => false do |t|
      t.string :condition_code
      t.date :validity_start_date

      t.timestamps
    end
  end
end
