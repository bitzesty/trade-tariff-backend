require 'commodity_mapper'

class Commodity < GoodsNomenclature
  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE ?", '____000000').
              order(:goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  one_to_many :measures, dataset: -> {
    Measure.actual
           .relevant
           .filter('goods_nomenclature_sid IN ?', uptree.map(&:goods_nomenclature_sid))
  }

  one_to_one :heading, dataset: -> {
    Heading.actual
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
  }

  one_to_one :chapter, dataset: -> {
    Chapter.actual
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", chapter_id)
  }

  delegate :section, to: :chapter

  def_dataset_method(:by_code) do |code|
    filter(goods_nomenclature_item_id: code.first(10), producline_suffix: code.last(2))
  end

  def ancestors
    @_ancestors ||= begin
                      commodities = heading.commodities_dataset.eager_graph(:goods_nomenclature_indent).all
                      heading = heading_dataset.eager_graph(:goods_nomenclature_indent).all
                      commodity = CommodityMapper.new(heading + commodities)
                                                 .for_commodity(self)

                      commodity.ancestors
                    end
  end

  def uptree
    ancestors << self
  end
end
