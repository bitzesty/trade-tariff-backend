class CreateQuotaReopeningEvents < ActiveRecord::Migration
  def change
    create_table :quota_reopening_events, :id => false do |t|
      t.integer :quota_definition_sid
      t.datetime :occurrence_timestamp
      t.date :reopening_date

      t.timestamps
    end
  end
end
