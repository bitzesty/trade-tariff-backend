class ExportRefundNomenclatureDescription < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: :export_refund_nomenclature_period_sid
  plugin :conformance_validator

  set_primary_key [:export_refund_nomenclature_description_period_sid]
end
