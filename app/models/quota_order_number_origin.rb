class QuotaOrderNumberOrigin < Sequel::Model
  set_primary_key  :quota_order_number_origin_sid

  # belongs_to :geographical_area, foreign_key: :geographical_area_sid
  # belongs_to :quota_order_number, foreign_key: :quota_order_number_sid

  # has_many :quota_order_number_origin_exclusions, foreign_key: :quota_order_number_origin_sid
  # has_many :excluded_quota_order_number_origin_geographical_areas, through: :quota_order_number_origin_exclusions,
                                                                   # source: :excluded_geographical_area
end


