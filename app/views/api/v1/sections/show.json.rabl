object @section
attributes :id, :title, :numeral, :position
child(chapters: :chapters) do
    attributes :id, :description, :code, :short_code
end
