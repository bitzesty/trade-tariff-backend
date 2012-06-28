class FootnoteAssociationMeasure < ActiveRecord::Base
  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :footnote
  belongs_to :footnote_type
end
