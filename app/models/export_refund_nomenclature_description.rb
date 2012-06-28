class ExportRefundNomenclatureDescription < ActiveRecord::Base
  self.primary_key = :export_refund_nomenclature_description_period_sid

  belongs_to :export_refund_nomenclature, foreign_key: :export_refund_nomenclature_sid
  belongs_to :goods_nomenclature_item
  belongs_to :additional_code_type
  belongs_to :export_refund_code, foreign_key: :export_refund_code, class_name: 'AdditionalCodeType'
end
