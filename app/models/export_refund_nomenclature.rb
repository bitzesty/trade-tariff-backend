class ExportRefundNomenclature < ActiveRecord::Base
  self.primary_key = :export_refund_nomenclature_sid

  has_many :export_refund_nomenclature_indents, foreign_key: :export_refund_nomenclature_sid
end
