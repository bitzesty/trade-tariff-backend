class FootnoteDescriptionPeriod < ActiveRecord::Base
  has_many :footnote_descriptions
  belongs_to :footnote_type
  belongs_to :footnote
end
