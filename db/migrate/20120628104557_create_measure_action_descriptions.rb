class CreateMeasureActionDescriptions < ActiveRecord::Migration
  def change
    create_table :measure_action_descriptions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.string :action_code
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
