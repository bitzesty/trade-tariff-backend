class CreateMeasureTypeSeries < ActiveRecord::Migration
  def change
    create_table :measure_type_series, :id => false do |t|
      t.string :measure_type_series_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :measure_type_combination

      t.timestamps
    end
  end
end
