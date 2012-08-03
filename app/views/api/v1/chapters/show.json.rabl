object @chapter
attributes :goods_nomenclature_item_id, :description
child :section do
  attributes :title, :position, :numeral
end

node(:headings) do
  @headings.map do |heading|
    partial("api/v1/headings/heading", object: heading)
  end
end
