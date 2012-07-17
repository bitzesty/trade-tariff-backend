attributes :measure_sid, :origin, :duty_rate

node(:measure_type_description) { |obj|
  obj.measure_type_description.description
}

node(:legal_act, if: ->(measure) { measure.generating_regulation_present? }) do |obj|
  {
    generating_regulation_code: obj.generating_regulation_code,
    url: obj.generating_regulation_url
  }
end

child(measure_conditions: :conditions) do
  attributes :condition_code, :action_code
  node(:description) { |obj|
    obj.measure_action.measure_action_description.description
  }
  node(:requirement) { |obj|
    if obj.certificate.present?
      obj.certificate.certificate_description.description
    end
  }
end

child(region: :region) do
  attributes :name, :description
  node(:type) { |r| r.class_name }
  node(:countries, if: ->(region) { region.class_name == 'CountryGroup' }) do |region|
    child(countries: :countries) do
      attributes :name
    end
  end
end

# child(excluded_countries: :excluded_countries) do
#   attributes :name, :iso_code
# end

# child(footnotes: :footnotes) do
#   attributes :id, :code, :description
# end

# child(additional_codes: :additional_codes) do
#   attributes :id, :code, :description
# end

