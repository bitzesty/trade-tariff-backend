class CreateQuotaSuspensionPeriods < ActiveRecord::Migration
  def change
    create_table :quota_suspension_periods, :id => false do |t|
      t.integer :quota_suspension_period_sid
      t.integer :quota_definition_sid
      t.date :suspension_start_date
      t.date :suspension_end_date
      t.text :description

      t.timestamps
    end
  end
end
