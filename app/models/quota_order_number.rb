class QuotaOrderNumber < Sequel::Model
  set_primary_key  :quota_order_number_sid

  # has_many :quota_order_number_origins, foreign_key: :quota_order_number_sid
  # has_many :quota_order_number_origin_geographical_areas, through: :quota_order_number_origins,
  #                                                         source: :geographical_area,
  #                                                         class_name: 'GeographicalArea'
end


