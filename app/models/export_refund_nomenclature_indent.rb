class ExportRefundNomenclatureIndent < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  belongs_to :export_refund_nomenclature
  # belongs_to :additional_code_type
  # belongs_to :export_refund_code, foreign_key: :export_refund_code, class_name: 'AdditionalCodeType'
end
