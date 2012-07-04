class FootnoteDescriptionPeriod < ActiveRecord::Base
  self.primary_key = :footnote_description_period_sid

  has_many :footnote_descriptions
  belongs_to :footnote_type
  belongs_to :footnote
end

# == Schema Information
#
# Table name: footnote_description_periods
#
#  record_code                     :string(255)
#  subrecord_code                  :string(255)
#  record_sequence_number          :string(255)
#  footnote_description_period_sid :string(255)     primary key
#  footnote_type_id                :string(255)
#  footnote_id                     :string(255)
#  validity_start_date             :date
#  created_at                      :datetime
#  updated_at                      :datetime
#

