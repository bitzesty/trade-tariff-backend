class QuotaOrderNumberOriginExclusion < ActiveRecord::Base
  set_primary_keys :quota_order_number_origin_sid, :excluded_geographical_area_sid

  belongs_to :quota_order_number_origin, foreign_key: :quota_order_number_origin_sid
  belongs_to :excluded_geographical_area, foreign_key: :excluded_geographical_area_sid,
                                          class_name: 'GeographicalArea'
end

# == Schema Information
#
# Table name: quota_order_number_origin_exclusions
#
#  record_code                    :string(255)
#  subrecord_code                 :string(255)
#  record_sequence_number         :string(255)
#  quota_order_number_origin_sid  :integer(4)
#  excluded_geographical_area_sid :integer(4)
#  created_at                     :datetime
#  updated_at                     :datetime
#

