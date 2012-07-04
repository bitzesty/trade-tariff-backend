class QuotaSuspensionPeriod < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :quota_definition, primary_key: :quota_definition_sid
end

# == Schema Information
#
# Table name: quota_suspension_periods
#
#  record_code                 :string(255)
#  subrecord_code              :string(255)
#  record_sequence_number      :string(255)
#  quota_suspension_period_sid :integer(4)
#  quota_definition_sid        :integer(4)
#  suspension_start_date       :date
#  suspension_end_date         :date
#  description                 :text
#  created_at                  :datetime
#  updated_at                  :datetime
#

