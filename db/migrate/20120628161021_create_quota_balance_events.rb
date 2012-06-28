class CreateQuotaBalanceEvents < ActiveRecord::Migration
  def change
    create_table :quota_balance_events, :id => false do |t|
      t.integer :quota_definition_sid
      t.datetime :occurrence_timestamp
      t.integer :old_balance
      t.integer :new_balance
      t.integer :imported_amount

      t.timestamps
    end
  end
end
