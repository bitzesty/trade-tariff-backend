class FootnoteType < ActiveRecord::Base
  self.primary_keys =  :footnote_type_id

  has_many :footnotes, foreign_key: :footnote_type_id
  has_many :footnote_description, foreign_key: :footnote_type_id
  has_many :footnote_description_periods, foreign_key: :footnote_type_id
  has_one  :footnote_type_description, foreign_key: :footnote_type_id

  APPLICATION_CODES = {
    1 => "CN nomencalture",
    2 => "TARIC nomencalture",
    3 => "Export refund nomencalture",
    5 => "Additional codes",
    6 => "CN Measures",
    7 => "Other Measures",
    8 => "Measuring Heading",
  }
end

# == Schema Information
#
# Table name: footnote_types
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  footnote_type_id       :string(255)
#  application_code       :integer(4)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

