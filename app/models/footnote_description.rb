class FootnoteDescription < ActiveRecord::Base
  belongs_to :footnote
  belongs_to :footnote_description_period, foreign_key: :footnote_description_period_sid
  belongs_to :footnote_type
end
