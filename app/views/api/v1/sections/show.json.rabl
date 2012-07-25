object @section
attributes :position, :title, :numeral
child(chapters: :chapters) do
  attributes :short_code, :description, :code
end
