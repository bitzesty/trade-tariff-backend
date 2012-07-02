class CreateQuotaUnblockingEvents < ActiveRecord::Migration
  def change
    create_table :quota_unblocking_events, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :quota_definition_sid
      t.datetime :occurrence_timestamp
      t.date :unblocking_date

      t.timestamps
    end
  end
end
