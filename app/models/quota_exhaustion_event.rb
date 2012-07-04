class QuotaExhaustionEvent < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :quota_definition, foreign_key: :quota_definition_sid
end

# == Schema Information
#
# Table name: quota_exhaustion_events
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  quota_definition_sid   :integer(4)
#  occurrence_timestamp   :datetime
#  exhaustion_date        :date
#  created_at             :datetime
#  updated_at             :datetime
#

