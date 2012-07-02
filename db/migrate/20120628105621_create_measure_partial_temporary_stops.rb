class CreateMeasurePartialTemporaryStops < ActiveRecord::Migration
  def change
    create_table :measure_partial_temporary_stops, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :measure_sid
      t.date :validity_start_date
      t.date :validity_end_date
      t.string :partial_temporary_stop_regulation_id
      t.string :partial_temporary_stop_regulation_officialjournal_number
      t.integer :partial_temporary_stop_regulation_officialjournal_page
      t.string :abrogation_regulation_id
      t.string :abrogation_regulation_officialjournal_number
      t.integer :abrogation_regulation_officialjournal_page

      t.timestamps
    end
  end
end
