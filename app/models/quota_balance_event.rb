class QuotaBalanceEvent < Sequel::Model
  set_primary_key  [:quota_definition_sid, :occurance_timestamp]

  # belongs_to :quota_definition, foreign_key: :quota_definition_sid
end

# == Schema Information
#
# Table name: quota_balance_events
#
#  record_code                    :string(255)
#  subrecord_code                 :string(255)
#  record_sequence_number         :string(255)
#  quota_definition_sid           :integer(4)
#  occurrence_timestamp           :datetime
#  last_import_date_in_allocation :date
#  old_balance                    :integer(4)
#  new_balance                    :integer(4)
#  imported_amount                :integer(4)
#  created_at                     :datetime
#  updated_at                     :datetime
#

