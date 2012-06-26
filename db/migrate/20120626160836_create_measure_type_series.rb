class CreateMeasureTypeSeries < ActiveRecord::Migration
  def change
    create_table :measure_type_series do |t|
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :combination

      t.timestamps
    end
  end
end
