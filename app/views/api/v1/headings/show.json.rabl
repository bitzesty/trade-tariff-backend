object @heading
attributes :short_code, :code, :description, :has_measures,
    :third_country_duty_cache, :uk_vat_rate_cache, :declarative

child :chapter do
  attributes :short_code, :code
  node(:description) { |chapter| chapter.goods_nomenclature_descriptions.first.description }
end

child @heading.chapter.section do
  attributes :title, :numeral, :position
end

node(:commodities) {
  @commodities.map do |commodity|
    {
      code: commodity.goods_nomenclature_item_id,
      leaf: commodity.leaf?,
      description: commodity.goods_nomenclature_descriptions.first.description,
      indent: commodity.goods_nomenclature_indent.number_indents,
      commodities: commodity.children.map { |commodity|
        {
          code: commodity.goods_nomenclature_item_id,
          leaf: commodity.leaf?,
          description: commodity.goods_nomenclature_descriptions.first.description,
        }
      }
    }
  end
}

