class ExportRefundNomenclatureDescriptionPeriod < Sequel::Model
  set_primary_key [:export_refund_nomenclature_sid, :export_refund_nomenclature_description_period_sid]

  # belongs_to :export_refund_nomenclature, foreign_key: :export_refund_nomenclature_sid
  # belongs_to :export_refund_nomenclature_description, foreign_key: :export_refund_nomenclature_description_period_sid
end


