class CreateMeasureConditionCodeDescriptions < ActiveRecord::Migration
  def change
    create_table :measure_condition_code_descriptions, :id => false do |t|
      t.string :condition_code
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
