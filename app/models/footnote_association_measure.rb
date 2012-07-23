class FootnoteAssociationMeasure < Sequel::Model
  set_primary_key :measure_sid, :footnote_id, :footnote_type_id

  # belongs_to :measure, foreign_key: :measure_sid
  # belongs_to :footnote, foreign_key: :footnote_id
end


