class CreateAdditionalCodeTypeMeasureTypes < ActiveRecord::Migration
  def change
    create_table :additional_code_type_measure_types, :id => false do |t|
      t.string :measure_type_id
      t.string :additional_code_type_id
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
