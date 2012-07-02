class CreateMeasureActions < ActiveRecord::Migration
  def change
    create_table :measure_actions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.string :action_code
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
