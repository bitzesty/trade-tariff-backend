class FootnoteAssociationErn < Sequel::Model
  set_primary_key [:export_refund_nomenclature_sid, :footnote_id, :footnote_type,
                         :validity_start_date]

  # belongs_to :export_refund_nomenclature, foreign_key: :export_refund_nomenclature_sid
  # belongs_to :footnote
end


