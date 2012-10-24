class FootnoteAssociationErn < Sequel::Model
  set_primary_key [:export_refund_nomenclature_sid, :footnote_id, :footnote_type,
                         :validity_start_date]
end


