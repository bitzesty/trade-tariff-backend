class CreateMonetaryExchangeRates < ActiveRecord::Migration
  def change
    create_table :monetary_exchange_rates, :id => false do |t|
      t.string :monetary_exchange_period_sid
      t.string :child_monetary_unit_code
      t.decimal :exchange_rate, :scale => 8, :precision => 16

      t.timestamps
    end
  end
end
