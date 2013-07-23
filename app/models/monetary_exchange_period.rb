class MonetaryExchangePeriod < Sequel::Model
  plugin :oplog, primary_key: [:monetary_exchange_period_sid,
                               :parent_monetary_unit_code]
  plugin :conformance_validator

  set_primary_key  [:monetary_exchange_period_sid, :parent_monetary_unit_code]
end


