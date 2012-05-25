json.id           measure.id
json.measure_type measure.measure_type
json.duty_rates   measure.duty_rates
if measure.legal_act.present?
  json.legal_act do |json|
    json.id   measure.legal_act.id
    json.code measure.legal_act.code
    json.url  measure.legal_act.url
  end
end
json.conditions   measure.conditions do |json, condition|
  json.partial! "api/v1/conditions/condition", condition: condition
end
json.excluded_countries measure.excluded_countries do |json, country|
  json.id       country.id
  json.name     country.name
  json.iso_code country.iso_code
end
json.footnotes measure.footnotes do |json, footnote|
  json.id          footnote.id
  json.code        footnote.code
  json.description footnote.description
end
json.additional_codes measure.additional_codes do |json, code|
  json.id          code.id
  json.code        code.code
  json.description code.description
end
json.region do |json|
  unless measure.ergo_omnes?
    json.id   measure.region.id
    json.type measure.region.class.name
    json.name measure.region.name
    if measure.region.is_a?(Country)
      json.iso_code measure.region.iso_code
    else
      json.description measure.region.description
    end
  end
end
