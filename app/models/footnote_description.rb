class FootnoteDescription < Sequel::Model
  plugin :time_machine

  set_primary_key :footnote_id, :footnote_type_id, :footnote_description_period_sid
end

# == Schema Information
#
# Table name: footnote_descriptions
#
#  record_code                     :string(255)
#  subrecord_code                  :string(255)
#  record_sequence_number          :string(255)
#  footnote_description_period_sid :string(255)
#  footnote_type_id                :string(255)
#  footnote_id                     :string(255)
#  language_id                     :string(255)
#  description                     :text
#  created_at                      :datetime
#  updated_at                      :datetime
#

