class Heading < GoodsNomenclature
  default_scope where("goods_nomenclature_item_id LIKE '____000000' AND
                       goods_nomenclature_item_id NOT LIKE '__00______'")
end
