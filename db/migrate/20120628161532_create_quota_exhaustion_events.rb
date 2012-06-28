class CreateQuotaExhaustionEvents < ActiveRecord::Migration
  def change
    create_table :quota_exhaustion_events, :id => false do |t|
      t.integer :quota_definition_sid
      t.datetime :occurrence_timestamp
      t.date :exhaustion_date

      t.timestamps
    end
  end
end
