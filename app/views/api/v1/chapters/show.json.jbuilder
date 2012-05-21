json.id           @chapter.id
json.code         @chapter.code
json.description  @chapter.description
json.headings     @chapter.headings do |json, heading|
  json.id          heading.id
  json.description heading.description
end
