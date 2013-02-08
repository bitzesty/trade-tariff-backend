class MonetaryExchangeRate < Sequel::Model
  plugin :oplog, primary_key: [:monetary_exchange_period_sid,
                               :child_monetary_unit_code]
  set_primary_key  :monetary_exchange_period_sid, :child_monetary_unit_code
end


