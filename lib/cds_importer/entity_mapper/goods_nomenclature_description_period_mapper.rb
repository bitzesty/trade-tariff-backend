class CdsImporter
  class EntityMapper
    class GoodsNomenclatureDescriptionPeriodMapper < BaseMapper
      self.entity_class = "GoodsNomenclatureDescriptionPeriod".freeze

      self.mapping_root = "GoodsNomenclature".freeze

      self.mapping_path = "goodsNomenclatureDescriptionPeriod".freeze

      self.exclude_mapping = ["metainfo.origin"].freeze

      self.entity_mapping = base_mapping.merge(
        "sid" => :goods_nomenclature_sid,
        "#{mapping_path}.sid" => :goods_nomenclature_description_period_sid,
        "goodsNomenclatureItemId" => :goods_nomenclature_item_id,
        "produclineSuffix" => :productline_suffix
      ).freeze

      self.entity_mapping_key_as_array = mapping_with_key_as_array.freeze

      self.entity_mapping_keys_to_parse = mapping_keys_to_parse.freeze
    end
  end
end
