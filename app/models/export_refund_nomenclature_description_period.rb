class ExportRefundNomenclatureDescriptionPeriod < Sequel::Model
  plugin :time_machine

  set_primary_key [:export_refund_nomenclature_sid, :export_refund_nomenclature_description_period_sid]
end


