class QuotaOrderNumberOriginExclusion < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number
  
  belongs_to :quota_order_number_origin, foreign_key: :quota_order_number_origin_sid
  belongs_to :excluded_geographical_area, foreign_key: :excluded_geographical_area_sid,
                                          class_name: 'GeographicalArea'
end
