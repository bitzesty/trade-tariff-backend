class CreateQuotaUnsuspensionEvents < ActiveRecord::Migration
  def change
    create_table :quota_unsuspension_events, :id => false do |t|
      t.integer :quota_definition_sid
      t.datetime :occurrence_timestamp
      t.date :unsuspension_date

      t.timestamps
    end
  end
end
