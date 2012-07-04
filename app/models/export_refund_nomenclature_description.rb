class ExportRefundNomenclatureDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :export_refund_nomenclature, foreign_key: :export_refund_nomenclature_sid
  # belongs_to :additional_code_type
  # belongs_to :export_refund_code, foreign_key: :export_refund_code, class_name: 'AdditionalCodeType'
  belongs_to :language
end
