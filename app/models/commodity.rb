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

  one_to_many :import_measures, dataset: -> {
    measures_dataset.join(:measure_types, measure_type_id: :measure_type)
                    .where(trade_movement_code: MeasureType::IMPORT_MOVEMENT_CODES)
  }, class_name: 'Measure'

  one_to_many :export_measures, dataset: -> {
    measures_dataset.join(:measure_types, measure_type_id: :measure_type)
                    .where(trade_movement_code: MeasureType::EXPORT_MOVEMENT_CODES)
  }, class_name: 'Measure'

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
    @_ancestors ||= tree_map.for_commodity(self).ancestors
  end

  def uptree
    ancestors << self
  end

  def children
    @_children ||= tree_map.for_commodity(self).children
  end

  # TODO calculate real rate
  def third_country_duty_rate
    "0.00 %"
  end

  private

  def tree_map
    @_tree_map ||= begin
                      commodities = heading.commodities_dataset.eager_graph(:goods_nomenclature_indent).all
                      heading = heading_dataset.eager_graph(:goods_nomenclature_indent).all
                      commodity = CommodityMapper.new(heading + commodities)
                   end
  end
end
