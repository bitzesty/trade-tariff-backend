#
# There is no collection with ExportRefundNomenclatureIndent in new xml.
# ExportRefundNomenclatureIndent is nested in to ExportRefundNomenclature.
# We will pass @values for ExportRefundNomenclatureIndent the same as for ExportRefundNomenclature
#

class CdsImporter
  class EntityMapper
    class ExportRefundNomenclatureIndentMapper < BaseMapper
      self.mapping_path = "exportRefundNomenclatureIndents".freeze

      self.exclude_mapping = ["metainfo.origin"].freeze

      self.entity_class = "ExportRefundNomenclatureIndent".freeze

      self.entity_mapping = base_mapping.merge(
        "exportRefundNomenclatureIndents.sid" => :export_refund_nomenclature_indents_sid,
        "sid" => :export_refund_nomenclature_sid,
        "exportRefundNomenclatureIndents.numberExportRefundNomenclatureIndents" => :number_export_refund_nomenclature_indents,
        "goodsNomenclature.goodsNomenclatureItemId" => :goods_nomenclature_item_id,
        "additionalCodeType.additionalCodeTypeId" => :additional_code_type,
        "exportRefundCode" => :export_refund_code,
        "productLine" => :productline_suffix
      ).freeze
    end
  end
end
