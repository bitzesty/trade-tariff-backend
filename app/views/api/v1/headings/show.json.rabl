object @heading
attributes :id, :code, :description, :short_code
child :chapter do
  attributes :id, :code, :description, :short_code
end
child @heading.chapter.section do
  attributes :id, :title, :numeral, :position
end
if @heading.has_measures?
  child Hash[@heading.measures.import, :import_measures] do |measure|
    extends "api/v1/measures/_measures"
  end

  child Hash[@heading.measures.export, :export_measures] do |measure|
    extends "api/v1/measures/_measures"
  end
else
  child(commodities: :commodities) do
    attributes :id, :code, :description, :substring, :short_code
  end
end
