class CreateMeasureActionDescriptions < ActiveRecord::Migration
  def change
    create_table :measure_action_descriptions, :id => false do |t|
      t.string :action_code
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
