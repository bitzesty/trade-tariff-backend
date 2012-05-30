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

child @commodity.measures.import, as: :import_measures do |measure|
  extends "commodities/measures"
end

child @commodity.measures.export, as: :export_measures do |measure|
  extends "commodities/measures"
end
