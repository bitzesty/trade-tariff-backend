class Footnote < ActiveRecord::Base
  self.primary_key = :footnote_id

  belongs_to :footnote_type, primary_key: :footnote_type
  has_one :footnote_description
end
