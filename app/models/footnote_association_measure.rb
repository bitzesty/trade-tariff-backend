class FootnoteAssociationMeasure < Sequel::Model
  set_primary_key :measure_sid, :footnote_id, :footnote_type_id

  plugin :timestamps

  one_to_one :footnote, key: :footnote_id,
                        primary_key: :footnote_id
  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid
end


