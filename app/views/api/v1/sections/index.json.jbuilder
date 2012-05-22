json.array!(@sections) do |json, section|
  json.id       section.id
  json.title    section.title
  json.numeral  section.numeral
  json.position section.position
end
