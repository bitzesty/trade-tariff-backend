class CdsImporter
  class EntityMapper
    class GoodsNomenclatureDescriptionPeriodMapper < BaseMapper
      self.exclude_mapping = ["metainfo.origin"].freeze
      self.mapping_path = "goodsNomenclatureDescriptionPeriod".freeze
      self.entity_class = "GoodsNomenclatureDescriptionPeriod".freeze
      self.entity_mapping = base_mapping.merge(
        "sid" => :goods_nomenclature_sid,
        "#{mapping_path}.sid" => :goods_nomenclature_description_period_sid,
        "goodsNomenclatureItemId" => :goods_nomenclature_item_id,
        "produclineSuffix" => :productline_suffix
      ).freeze
    end
  end
end
