object @commodity

extends "api/v1/commodities/commodity"

child @commodity.section do
  attributes :title, :position
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
