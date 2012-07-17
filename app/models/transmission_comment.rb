class TransmissionComment < Sequel::Model
  set_primary_key [:comment_sid, :language_id]

  many_to_one :language
end

# == Schema Information
#
# Table name: transmission_comments
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  comment_sid            :integer(4)
#  language_id            :string(255)
#  comment_text           :text
#  created_at             :datetime
#  updated_at             :datetime
#

