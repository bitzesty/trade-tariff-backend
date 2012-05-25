json.id           @heading.id
json.code         @heading.code
json.description  @heading.description
json.partial! "api/v1/commodities/commodities", commodities: @heading.commodities
json.chapter do |json|
  json.partial! "api/v1/chapters/chapter", chapter: @heading.chapter
end
json.section do |json|
  json.partial! "api/v1/sections/section", section: @heading.chapter.section
end
