class Heading < GoodsNomenclature
  default_scope where("goods_nomenclatures.goods_nomenclature_item_id LIKE '____000000' AND
                       goods_nomenclatures.goods_nomenclature_item_id NOT LIKE '__00______'")

  def chapter
    Chapter.where("goods_nomenclature_item_id LIKE ?", chapter_id).first
  end

  def code
    goods_nomenclature_item_id
  end

  def short_code
    code.first(4)
  end

  def declarative
  end

  def heading_id
    "#{goods_nomenclature_item_id.first(4)}______"
  end

  private

  def chapter_id
    goods_nomenclature_item_id.first(2) + "0" * 8
  end
end
