json.commodities commodities do |json, commodity|
  json.partial! "api/v1/commodities/commodity", commodity: commodity
end
