object @chapter
attributes :short_code, :code
  node(:description) { |chapter| chapter.goods_nomenclature_descriptions.first.description }
child :section do
  attributes :title, :position, :numeral
end
child(headings: :headings) do
  attributes :short_code, :code, :declarative
  node(:description) { |heading| heading.goods_nomenclature_descriptions.first.description }
end
