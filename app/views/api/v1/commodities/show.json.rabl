object @commodity

extends "api/v1/commodities/commodity"

child @commodity.section do
  attributes :title, :position, :numeral
end

child @commodity.chapter do
  attributes :short_code, :code, :description
end

child @commodity.heading do
  attributes :short_code, :code, :description, :description
end

node(:ancestors) { |commodity|
  @commodity.ancestors.map do |commodity|
    partial("api/v1/commodities/commodity_base", object: commodity)
  end
}

node(:import_measures) { |commodity|
  commodity.import_measures.map do |import_measure|
    partial "api/v1/measures/measure", object: import_measure
  end
}

node(:export_measures) { |commodity|
  commodity.export_measures.map do |export_measure|
    partial "api/v1/measures/_measure", object: export_measure
  end
}
