class MonetaryUnitDescription < Sequel::Model
  plugin :oplog, primary_key: :monetary_unit_code
  set_primary_key [:monetary_unit_code]
end


