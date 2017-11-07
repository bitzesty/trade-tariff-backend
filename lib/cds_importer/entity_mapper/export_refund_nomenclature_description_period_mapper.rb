#
# There is no collection with ExportRefundNomenclatureDescriptionPeriod in new xml.
# ExportRefundNomenclatureDescriptionPeriod is nested in to ExportRefundNomenclature.
# We will pass @values for ExportRefundNomenclatureDescriptionPeriod the same as for ExportRefundNomenclature.
#

class CdsImporter
  class EntityMapper
    class ExportRefundNomenclatureDescriptionPeriodMapper < BaseMapper
      self.mapping_path = "exportRefundNomenclatureDescriptionPeriod".freeze

      self.exclude_mapping = ["metainfo.origin"].freeze

      self.entity_class = "ExportRefundNomenclatureDescriptionPeriod".freeze

      self.entity_mapping = base_mapping.merge(
        "#{mapping_path}.sid" => :export_refund_nomenclature_description_period_sid,
        "sid" => :export_refund_nomenclature_sid,
        "goodsNomenclature.goodsNomenclatureItemId" => :goods_nomenclature_item_id,
        "additionalCodeType.additionalCodeTypeId" => :additional_code_type,
        "exportRefundCode" => :export_refund_code,
        "productLine" => :productline_suffix
      ).freeze
    end
  end
end
