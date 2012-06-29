class ExportRefundNomenclatureIndents < ActiveRecord::Base
  self.primary_key = :export_refund_nomenclature_indents_sid

  belongs_to :export_refund_nomenclature
  # belongs_to :additional_code_type
  belongs_to :export_refund_code, foreign_key: :export_refund_code, class_name: 'AdditionalCodeType'
end
