json.id           @commodity.id
json.code         @commodity.code
json.description  @commodity.description
json.heading do |json|
  json.partial! "api/v1/headings/heading", heading: @commodity.heading
end
json.chapter do |json|
  json.partial! "api/v1/chapters/chapter", chapter: @commodity.heading.chapter
end
json.section do |json|
  json.partial! "api/v1/sections/section", section: @commodity.heading.chapter.section
end
json.partial! "api/v1/measures/measures", measures: @commodity.measures
