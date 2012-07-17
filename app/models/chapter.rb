require_relative 'goods_nomenclature'

class Chapter < GoodsNomenclature
  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", '__00000000').
              order(:goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  def substring
    goods_nomenclature_indent.number_indentys
  end
  # has_and_belongs_to_many :sections, foreign_key: :goods_nomenclature_sid

  # default_scope where("goods_nomenclatures.goods_nomenclature_item_id LIKE '__00000000'")

  # def headings
  #   Heading.where("goods_nomenclature_item_id LIKE ? AND goods_nomenclature_item_id NOT LIKE '__00______'", goods_nomenclature_item_id.first(2) + "_" * 8)
  # end

  # def code
  #   goods_nomenclature_item_id
  # end

  # def short_code
  #   goods_nomenclature_item_id.first(2)
  # end

  # def section
  #   sections.first
  # end
end
