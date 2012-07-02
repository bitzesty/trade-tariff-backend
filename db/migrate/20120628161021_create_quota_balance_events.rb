class CreateQuotaBalanceEvents < ActiveRecord::Migration
  def change
    create_table :quota_balance_events, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :quota_definition_sid
      t.datetime :occurrence_timestamp
      t.date :last_import_date_in_allocation
      t.integer :old_balance
      t.integer :new_balance
      t.integer :imported_amount

      t.timestamps
    end
  end
end
