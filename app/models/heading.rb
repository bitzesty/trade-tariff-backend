class Heading < GoodsNomenclature
  set_dataset filter(:goods_nomenclature_item_id.like('____000000')).and(~:goods_nomenclature_item_id.like('__00______'))

  set_primary_key {}

  def_dataset_method(:valid_between) do |start_date, end_date|
    filter('validity_start_date <= ? AND (validity_end_date >= ? OR validity_end_date IS NULL)', start_date, end_date)
  end

  one_to_many :commodities, key: {}, dataset: -> {
    Commodity.where("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
  }

  # delegate :section, to: :chapter

  # def chapter
  #   Chapter.valid_between(validity_start_date, validity_end_date)
  #          .with_item_id(chapter_id)
  #          .first
  # end

  # def commodities
  # end

  def substring
    goods_nomenclature_indent.number_indents
  end

  # def code
  #   goods_nomenclature_item_id
  # end

  # def short_code
  #   code.first(4)
  # end

  # def declarative
  # end

  def heading_id
    "#{goods_nomenclature_item_id.first(4)}______"
  end

  # private

  # def chapter_id
  #   goods_nomenclature_item_id.first(2) + "0" * 8
  # end
end
