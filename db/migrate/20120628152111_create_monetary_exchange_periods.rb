class CreateMonetaryExchangePeriods < ActiveRecord::Migration
  def change
    create_table :monetary_exchange_periods do |t|
      t.string :monetary_exchange_period_sid
      t.string :parent_monetary_unit_code
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
