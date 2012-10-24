class MonetaryExchangePeriod < Sequel::Model
  set_primary_key  [:monetary_exchange_period_sid, :parent_monetary_unit_code]
end


