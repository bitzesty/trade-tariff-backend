class CreateQuotaExhaustionEvents < ActiveRecord::Migration
  def change
    create_table :quota_exhaustion_events, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :quota_definition_sid
      t.datetime :occurrence_timestamp
      t.date :exhaustion_date

      t.timestamps
    end
  end
end
