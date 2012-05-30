object @heading
attributes :id, :code, :description, :short_code
child :chapter do
  attributes :id, :code, :description, :short_code
end
child @heading.chapter.section do
  attributes :id, :title, :numeral, :position
end
child(commodities: :commodities) do
  attributes :id, :code, :description, :substring
end
