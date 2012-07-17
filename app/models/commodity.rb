require 'commodity_mapper'

class Commodity < GoodsNomenclature
  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE ?", '____000000').
              order(:goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  one_to_many :measures, dataset: -> {
    Measure.relevant_on(point_in_time)
           .filter('goods_nomenclature_sid IN ?', uptree.map(&:goods_nomenclature_sid))
  }

  one_to_one :heading, dataset: -> {
    Heading.valid_on(point_in_time)
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
  }

  one_to_one :chapter, dataset: -> {
    Chapter.valid_on(point_in_time)
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", chapter_id)
  }

  def ancestors
    @_ancestors ||= begin
                      commodities = heading.commodities_dataset.eager_graph(:goods_nomenclature_indent).valid_on(point_in_time).all
                      heading = heading_dataset.eager_graph(:goods_nomenclature_indent).valid_on(point_in_time).all
                      commodity = CommodityMapper.new(heading + commodities)
                                                 .for_commodity(self)

                      commodity.ancestors
                    end
  end

  def uptree
    ancestors << self
  end
end
