object @section
attributes :id, :title, :numeral
child(chapters: :chapters) do
    attributes :id, :description, :code
end
