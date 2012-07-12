class Commodity < GoodsNomenclature
  default_scope where("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE '____000000'")

  delegate :chapter, :section, to: :heading

  def heading
    Heading.where("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id).first
  end

  def code
    goods_nomenclature_item_id
  end

  def substring
    goods_nomenclature_indent.number_indents
  end

  private

  def heading_id
    goods_nomenclature_item_id.first(4) + "0" * 6
  end
end
