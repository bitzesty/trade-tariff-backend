class CreateMeasureTypeSeriesDescriptions < ActiveRecord::Migration
  def change
    create_table :measure_type_series_descriptions, :id => false do |t|
      t.string :measure_type_series_id
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
