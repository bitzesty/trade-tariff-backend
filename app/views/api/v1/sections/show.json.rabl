object @section
attributes :position, :title, :numeral
child(chapters: :chapters) do
  attributes :short_code, :description, :code
  node(:description) { |chapter| chapter.goods_nomenclature_descriptions.first.description }
end
