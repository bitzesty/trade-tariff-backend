class MonetaryExchangeRate < Sequel::Model
  set_primary_key  :monetary_exchange_period_sid, :child_monetary_unit_code
end


