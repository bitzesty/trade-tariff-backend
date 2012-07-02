class CreateQuotaBlockingPeriods < ActiveRecord::Migration
  def change
    create_table :quota_blocking_periods, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :quota_blocking_period_sid
      t.integer :quota_definition_sid
      t.date :blocking_start_date
      t.date :blocking_end_date
      t.integer :blocking_period_type
      t.text :description

      t.timestamps
    end
  end
end
