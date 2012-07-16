require 'commodity_mapper'
require 'sequel/plugins/time_machine'

class Commodity < GoodsNomenclature
  plugin :time_machine

  set_dataset filter(~:goods_nomenclature_item_id.like('____000000'))

  set_primary_key {}

  one_to_many :measures, key: {}, dataset: -> {
    commodity_sids = self.ancestor_sids << self.goods_nomenclature_sid
    # commodity_sids = [27624, 93797, 93796]

    point_in_time = BaseRegulation.now

    base_regulation_ids = BaseRegulation.valid_on(point_in_time)
                                        .select(:base_regulation_id)

    modification_regulation_ids = ModificationRegulation.valid_on(point_in_time)
                                                        .select(:modification_regulation_id)

    Measure.valid_on(Date.today)
           .filter({measure_generating_regulation_id:  base_regulation_ids} |
                   {measure_generating_regulation_id: modification_regulation_ids})
           .filter('goods_nomenclature_sid IN ?', commodity_sids)

  }, eager_load: -> {
  }

  one_to_one :heading, key: {}, dataset: -> {
    Heading.valid_between(validity_start_date, validity_end_date)
           .filter(goods_nomenclature_item_id: self.heading_id)
  }
  # default_scope where("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE '____000000'")

  # delegate :chapter, :section, to: :heading

  # def self.find_by_code(code)
  #   where{(goods_nomenclature_item_id.eq code.first(10)) & (producline_suffix.eq code.last(2))}.first
  # end

  # def heading
  # end

  # def code
  #   goods_nomenclature_item_id
  # end

  def substring
    goods_nomenclature_indent.number_indents
  end

  def ancestors
    @_ancestors ||= begin
                      commodities = heading.commodities #.with_indent
                      commodity = CommodityMapper.new([heading] + commodities)
                                                 .for_commodity(self)
                      commodity.ancestors
                    end
  end

  def ancestor_sids
    ancestors.map(&:goods_nomenclature_sid)
  end

  def heading_id
    goods_nomenclature_item_id.first(4) + "0" * 6
  end

end
