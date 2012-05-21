json.id           @section.id
json.title        @section.title
json.numeral      @section.numeral
json.chapters     @section.chapters do |json, chapter|
  json.id       chapter.id
  json.filename chapter.description
end
