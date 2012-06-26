class CreateMeasureTypeSeries < ActiveRecord::Migration
  def change
    create_table :measure_type_series, :id => false do |t|
      t.string :id
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :combination

      t.timestamps
    end
  end
end
