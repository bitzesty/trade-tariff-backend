class QuotaOrderNumberOrigin < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :geographical_area
end

# == Schema Information
#
# Table name: quota_order_number_origins
#
#  record_code                   :string(255)
#  subrecord_code                :string(255)
#  record_sequence_number        :string(255)
#  quota_order_number_origin_sid :integer(4)
#  quota_order_number_sid        :integer(4)
#  geographical_area_id          :string(255)
#  validity_start_date           :date
#  validity_end_date             :date
#  geographical_area_sid         :integer(4)
#  created_at                    :datetime
#  updated_at                    :datetime
#

