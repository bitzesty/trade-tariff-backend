object @heading
attributes :id, :code, :description
child :chapter do
  attributes :id, :code, :description
end
child @heading.chapter.section do
  attributes :id, :title
end
child(commodities: :commodities) do
  attributes :id, :code, :description, :substring
end
