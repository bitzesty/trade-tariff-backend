class QuotaOrderNumberOrigin < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: :quota_order_number_origin_sid
  plugin :conformance_validator

  set_primary_key [:quota_order_number_origin_sid]
end
