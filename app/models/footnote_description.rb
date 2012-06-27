class FootnoteDescription < ActiveRecord::Base
  belongs_to :footnote
  belongs_to :footnote_description_period
  belongs_to :footnote_type
end
