require 'commodity_mapper'

class Commodity < GoodsNomenclature
  default_scope where("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE '____000000'")

  delegate :chapter, :section, to: :heading

  def heading
    Heading.valid_between(validity_start_date, validity_end_date)
           .with_item_id(heading_id)
           .first
  end

  def code
    goods_nomenclature_item_id
  end

  def substring
    goods_nomenclature_indent.number_indents
  end

  def ancestors
    @_ancestors ||= begin
                      commodities = heading.commodities.with_indent
                      commodity = CommodityMapper.new([heading] + commodities)
                                                 .for_commodity(self)
                      commodity.ancestors
                    end
  end

  def ancestor_sids
    ancestors.map(&:goods_nomenclature_sid)
  end

  def measures(date = Date.today)
    commodity_sids = ancestor_sids << self.goods_nomenclature_sid

    base_regulation_ids = BaseRegulation.effective_on(date)
                                        .select{base_regulation_id}

    modification_regulation_ids = ModificationRegulation.effective_on(date)
                                                        .select{modification_regulation_id}

    Measure.valid_on(date)
           .where{measure_generating_regulation_id.in(base_regulation_ids) |
                  measure_generating_regulation_id.in(modification_regulation_ids)}
           .where{goods_nomenclature_sid.in commodity_sids}
  end

  private

  def heading_id
    goods_nomenclature_item_id.first(4) + "0" * 6
  end
end
