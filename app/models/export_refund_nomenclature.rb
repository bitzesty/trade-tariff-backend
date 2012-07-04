class ExportRefundNomenclature < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  has_many :export_refund_nomenclature_indents, foreign_key: :export_refund_nomenclature_sid
  has_many :export_refund_nomenclature_description_periods, foreign_key: :export_refund_nomenclature_description_period_sid
end
