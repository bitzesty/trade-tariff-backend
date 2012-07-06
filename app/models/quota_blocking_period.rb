class QuotaBlockingPeriod < ActiveRecord::Base
  self.primary_keys =  :quota_blocking_period_sid

  belongs_to :quota_definition, foreign_key: :quota_definition_sid
end

# == Schema Information
#
# Table name: quota_blocking_periods
#
#  record_code               :string(255)
#  subrecord_code            :string(255)
#  record_sequence_number    :string(255)
#  quota_blocking_period_sid :integer(4)
#  quota_definition_sid      :integer(4)
#  blocking_start_date       :date
#  blocking_end_date         :date
#  blocking_period_type      :integer(4)
#  description               :text
#  created_at                :datetime
#  updated_at                :datetime
#

