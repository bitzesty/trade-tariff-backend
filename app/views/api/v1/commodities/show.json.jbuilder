json.id           @commodity.id
json.code         @commodity.code
json.description  @commodity.description
json.heading do |json|
  json.id           @commodity.heading.id
  json.code         @commodity.heading.code
  json.description  @commodity.heading.description
end
json.chapter do |json|
  json.id           @commodity.heading.chapter.id
  json.description  @commodity.heading.chapter.description
  json.code         @commodity.heading.chapter.code
end
json.section do |json|
  json.id          @commodity.heading.chapter.section.id
  json.title       @commodity.heading.chapter.section.title
end
