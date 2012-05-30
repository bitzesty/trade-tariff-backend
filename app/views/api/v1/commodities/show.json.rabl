object @commodity
attribute :short_code, :code, :description, :synonyms
child @commodity.heading.chapter do
  attributes :short_code, :code, :description
end
child @commodity.heading.chapter.section do
  attributes :title, :position
end
child :heading do
  attributes :short_code, :code, :description
end

child Hash[@commodity.measures.import, :import_measures] do |measure|
  extends "api/v1/measures/_measures"
end

child Hash[@commodity.measures.export, :export_measures] do |measure|
  extends "api/v1/measures/_measures"
end
