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
end
