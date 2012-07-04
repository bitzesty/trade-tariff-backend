class TransmissionComment < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :language
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

