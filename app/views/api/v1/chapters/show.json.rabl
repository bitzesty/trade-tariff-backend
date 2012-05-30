object @chapter
attributes :short_code, :code, :description
child :section do
  attributes :title, :position, :numeral
end
child(headings: :headings) do
  attributes :short_code, :code, :description
end
