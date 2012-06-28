class FootnoteType < ActiveRecord::Base
  APPLICATION_CODES = {
    1 => "CN nomencalture",
    2 => "TARIC nomencalture",
    3 => "Export refund nomencalture",
    5 => "Additional codes",
    6 => "CN Measures",
    7 => "Other Measures",
    8 => "Measuring Heading",
  }

  self.primary_key = :footnote_type_id

  has_many :footnotes
  has_many :footnote_description
  has_many :footnote_description_periods
  has_one :footnote_type_description
end
