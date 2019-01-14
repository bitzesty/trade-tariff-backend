class MonetaryExchangePeriod < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: %i[monetary_exchange_period_sid
                                 parent_monetary_unit_code]
  plugin :conformance_validator

  set_primary_key %i[monetary_exchange_period_sid parent_monetary_unit_code]
end
