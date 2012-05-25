json.id           @chapter.id
json.code         @chapter.code
json.description  @chapter.description
json.partial! "api/v1/headings/headings", headings: @chapter.headings
json.section do |json|
  json.partial! "api/v1/sections/section", section: @chapter.section
end
