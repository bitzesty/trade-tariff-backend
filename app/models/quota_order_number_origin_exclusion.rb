class QuotaOrderNumberOriginExclusion < Sequel::Model
  set_primary_key  :quota_order_number_origin_sid, :excluded_geographical_area_sid

  # belongs_to :quota_order_number_origin, foreign_key: :quota_order_number_origin_sid
  # belongs_to :excluded_geographical_area, foreign_key: :excluded_geographical_area_sid,
                                          # class_name: 'GeographicalArea'
end


