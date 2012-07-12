object @commodity

extends "api/v1/commodities/commodity"

child @commodity.section do
  attributes :title, :position
end

child @commodity.chapter do
  attributes :short_code, :code
  node(:description) { |chapter|
    chapter.goods_nomenclature_descriptions.first.description
  }
end

child @commodity.heading do
  attributes :short_code, :code, :description
  node(:description) { |heading|
    heading.goods_nomenclature_descriptions.first.description
  }
end
