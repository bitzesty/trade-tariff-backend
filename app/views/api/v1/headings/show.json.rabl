object @heading
attributes :short_code, :code, :description
child :chapter do
  attributes :short_code, :code, :description
end
child @heading.chapter.section do
  attributes :title, :numeral, :position
end
if @heading.has_measures?
  child Hash[@heading.measures.for_import, :import_measures] do |measure|
    extends "api/v1/measures/_measures"
  end

  child Hash[@heading.measures.for_export, :export_measures] do |measure|
    extends "api/v1/measures/_measures"
  end
else
  child(commodities: :commodities) do
    attributes :short_code, :code, :description, :substring
  end
end
