class FootnoteTypeDescription < ActiveRecord::Base
  belongs_to :footnote_type
  belongs_to :language
end
