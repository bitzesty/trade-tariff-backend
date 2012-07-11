require_relative 'goods_nomenclature'

class Chapter < GoodsNomenclature
  has_and_belongs_to_many :sections, foreign_key: :goods_nomenclature_sid

  default_scope where("goods_nomenclatures.goods_nomenclature_item_id LIKE '__00000000'")

  def headings
    Heading.where("goods_nomenclature_item_id LIKE ? AND goods_nomenclature_item_id NOT LIKE '__00______'", goods_nomenclature_item_id.first(2) + "_" * 8)
  end

  def code
    goods_nomenclature_item_id
  end

  def short_code
    goods_nomenclature_item_id.first(2)
  end

  def section
    sections.first
  end
end
