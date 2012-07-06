class QuotaCriticalEvent < ActiveRecord::Base
  self.primary_keys =  :quota_definition_sid

  belongs_to :quota_definition, foreign_key: :quota_definition_sid
end

# == Schema Information
#
# Table name: quota_critical_events
#
#  record_code                :string(255)
#  subrecord_code             :string(255)
#  record_sequence_number     :string(255)
#  quota_definition_sid       :integer(4)
#  occurrence_timestamp       :datetime
#  critical_state             :string(255)
#  critical_state_change_date :date
#  created_at                 :datetime
#  updated_at                 :datetime
#

