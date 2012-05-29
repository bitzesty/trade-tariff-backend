object @chapter
attributes :id, :code, :description, :short_code
child :section do
  attributes :id, :title, :position, :numeral
end
child(headings: :headings) do
  attributes :id, :description, :code, :short_code
end
