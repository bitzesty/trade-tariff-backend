json.id           @heading.id
json.code         @heading.code
json.description  @heading.description
json.commodities  @heading.commodities do |json, commodity|
  json.id          commodity.id
  json.description commodity.description
end
