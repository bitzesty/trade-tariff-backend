class Chapter < GoodsNomenclature
  has_and_belongs_to_many :sections, foreign_key: :goods_nomenclature_sid

  default_scope where("goods_nomenclature_item_id LIKE '__00000000'")

  def short_code
    goods_nomenclature_item_id.first(2)
  end
end
