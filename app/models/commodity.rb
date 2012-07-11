class Commodity < GoodsNomenclature
  default_scope where("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE '____000000'")

  def chapter
    Chapter.where("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", chapter_id).first
  end

  def code
    goods_nomenclature_item_id
  end

  def substring
    goods_nomenclature_indent.number_indents
  end

  private

  def chapter_id
    goods_nomenclature_item_id.first(2) + "0" * 8
  end
end
