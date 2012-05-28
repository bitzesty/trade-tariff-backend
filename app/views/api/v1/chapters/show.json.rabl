object @chapter
attributes :id, :code, :description
child :section do
  attributes :id, :title
end
child(headings: :headings) do
  attributes :id, :description, :code
end
