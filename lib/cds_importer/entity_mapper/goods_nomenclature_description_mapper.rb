#
# There is no collection with GoodsNomenclatureDescription in new xml.
# GoodsNomenclatureDescription is nested in to GoodsNomenclatureDescriptionPeriod.
# GoodsNomenclatureDescriptionPeriod is nested in to GoodsNomenclature.
# We will pass @values for GoodsNomenclatureDescription the same as for GoodsNomenclature.
#

class CdsImporter
  class EntityMapper
    class GoodsNomenclatureDescriptionMapper < BaseMapper
      self.mapping_path = "goodsNomenclatureDescriptionPeriod.goodsNomenclatureDescription".freeze

      self.exclude_mapping = ["metainfo.origin", "validityStartDate", "validityEndDate"].freeze

      self.entity_class = "GoodsNomenclatureDescription".freeze

      self.entity_mapping = base_mapping.merge(
        "goodsNomenclatureDescriptionPeriod.sid" => :goods_nomenclature_description_period_sid,
        "#{mapping_path}.language.languageId" => :language_id,
        "sid" => :goods_nomenclature_sid,
        "goodsNomenclatureItemId" => :goods_nomenclature_item_id,
        "produclineSuffix" => :productline_suffix,
        "#{mapping_path}.description" => :description
      ).freeze
    end
  end
end