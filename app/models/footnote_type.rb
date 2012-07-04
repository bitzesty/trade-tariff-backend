class FootnoteType < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_many :footnotes
  has_many :footnote_description
  has_many :footnote_description_periods
  has_one :footnote_type_description

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

