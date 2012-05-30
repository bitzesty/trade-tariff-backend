object @commodity
attribute :id, :code, :description, :synonyms
child @commodity.heading.chapter do
  attributes :id, :code, :description, :short_code
end
child @commodity.heading.chapter.section do
  attributes :id, :title, :position
end
child :heading do
  attributes :id, :code, :description, :short_code
end

child Hash[@commodity.measures.import, :import_measures] do |measure|
  extends "api/v1/measures/_measures"
end

child Hash[@commodity.measures.export, :export_measures] do |measure|
  extends "api/v1/measures/_measures"
end
