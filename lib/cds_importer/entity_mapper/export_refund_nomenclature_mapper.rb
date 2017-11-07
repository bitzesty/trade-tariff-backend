class CdsImporter
  class EntityMapper
    class ExportRefundNomenclatureMapper < BaseMapper
      self.exclude_mapping = ["metainfo.origin"].freeze

      self.entity_class = "ExportRefundNomenclature".freeze

      self.entity_mapping = base_mapping.merge(
        "sid" => :export_refund_nomenclature_sid,
        "goodsNomenclature.goodsNomenclatureItemId" => :goods_nomenclature_item_id,
        "goodsNomenclature.sid" => :goods_nomenclature_sid,
        "additionalCodeType.additionalCodeTypeId" => :additional_code_type,
        "exportRefundCode" => :export_refund_code,
        "productLine" => :productline_suffix
      ).freeze
    end
  end
end
