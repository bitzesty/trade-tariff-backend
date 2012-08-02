object @section
attributes :position, :title, :numeral
child(chapters: :chapters) do
  attributes :description, :goods_nomenclature_item_id
end
