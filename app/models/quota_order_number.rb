class QuotaOrderNumber < Sequel::Model
  set_primary_key  :quota_order_number_sid

  # has_many :quota_order_number_origins, foreign_key: :quota_order_number_sid
  # has_many :quota_order_number_origin_geographical_areas, through: :quota_order_number_origins,
  #                                                         source: :geographical_area,
  #                                                         class_name: 'GeographicalArea'
end

# == Schema Information
#
# Table name: quota_order_numbers
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  quota_order_number_sid :integer(4)
#  quota_order_number_id  :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

