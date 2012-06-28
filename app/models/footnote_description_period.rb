class FootnoteDescriptionPeriod < ActiveRecord::Base
  self.primary_key = :footnote_description_period_sid

  has_many :footnote_descriptions
  belongs_to :footnote_type
  belongs_to :footnote
end
