object @commodity

extends "api/v1/commodities/commodity"
extends "api/v1/declarables/declarable", object: @commodity

child @commodity.heading do
  attributes :short_code, :code, :description, :description
end

node(:ancestors) { |commodity|
  @commodity.ancestors.map do |commodity|
    partial("api/v1/commodities/commodity_base", object: commodity)
  end
}
