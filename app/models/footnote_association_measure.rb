class FootnoteAssociationMeasure < Sequel::Model
  set_primary_key :measure_sid, :footnote_id, :footnote_type_id

  plugin :timestamps
end


