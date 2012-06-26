class CreateMeasureTypeSeriesDescriptions < ActiveRecord::Migration
  def change
    create_table :measure_type_series_descriptions do |t|
      t.integer :measure_type_series_id
      t.integer :language_id
      t.text :short_description

      t.timestamps
    end
  end
end
