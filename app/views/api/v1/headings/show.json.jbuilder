json.id           @heading.id
json.code         @heading.code
json.description  @heading.description
json.commodities  @heading.commodities do |json, commodity|
  json.id          commodity.id
  json.code        commodity.code
  json.description commodity.description
  json.substring   commodity.substring
end
json.chapter do |json|
  json.id           @heading.chapter.id
  json.description  @heading.chapter.description
  json.code         @heading.chapter.code
end
json.section do |json|
  json.id          @heading.chapter.section.id
  json.title       @heading.chapter.section.title
end
