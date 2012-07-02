class ExportRefundNomenclatureDescriptionPeriod < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_many :export_refund_nomenclature_descriptions, foreign_key: :export_refund_nomenclature_description_period_sid
  belongs_to :export_refund_nomenclature, foreign_key: :export_refund_nomenclature_sid
end
