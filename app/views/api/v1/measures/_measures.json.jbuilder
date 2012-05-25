json.measures     measures do |json, measure|
  json.partial! "api/v1/measures/measure", measure: measure
end
