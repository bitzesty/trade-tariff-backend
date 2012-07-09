class Commodity < GoodsNomenclature
  default_scope where("goods_nomenclature_item_id NOT LIKE '____000000'")
end
