node(:code) { |commodity|
  commodity.goods_nomenclature_item_id
}
node(:leaf) { |commodity|
  commodity.leaf?
}
node(:description) { |commodity|
  commodity.goods_nomenclature_descriptions.first.description
}
node(:indent) { |commodity|
  commodity.goods_nomenclature_indent.number_indents
}
node(:commodities) { |commodity|
  commodity.children.map do |commodity|
    partial("api/v1/commodities/commodity", object: commodity)
  end
}
