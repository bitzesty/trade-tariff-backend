class CreateQuotaCriticalEvents < ActiveRecord::Migration
  def change
    create_table :quota_critical_events, :id => false do |t|
      t.integer :quota_definition_sid
      t.datetime :occurrence_timestamp
      t.string :critical_state
      t.date :critical_state_change_date

      t.timestamps
    end
  end
end
