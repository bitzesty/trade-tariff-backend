class QuotaOrderNumberOriginExclusion < Sequel::Model
  plugin :oplog, primary_key: [:quota_order_number_origin_sid,
                               :excluded_geographical_area_sid]
  set_primary_key [:quota_order_number_origin_sid, :excluded_geographical_area_sid]
end


