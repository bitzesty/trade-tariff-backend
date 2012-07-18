attributes :measure_sid, :origin

node(:measure_type_description) { |obj|
  obj.measure_type_description.description
}

node(:legal_act, if: ->(measure) { measure.generating_regulation_present? }) do |obj|
  {
    generating_regulation_code: obj.generating_regulation_code,
    url: obj.generating_regulation_url
  }
end

child(measure_components: :components) do
  node(:duty_expression) { |obj|
    "#{obj.duty_amount} #{obj.duty_expression.duty_expression_description.description}"
  }
end

child(measure_conditions: :conditions) do
  attributes :document_code

  node(:action) { |obj|
    obj.measure_action.measure_action_description.description
  }
  node(:requirement) { |obj|
    if obj.certificate.present?
      obj.certificate.certificate_description.description
    end
  }
  node(:condition) { |obj|
    obj.measure_condition_code.measure_condition_code_description.description
  }
end

child(geographical_area: :region) do
  node(:iso_code) { |ga|
    ga.geographical_area_id
  }
  node(:description) { |ga|
    ga.geographical_area_description.description
  }
  node(:countries, if: ->(region) { region.children_geographical_areas.any? }) do |region|
    child(contained_geographical_areas: :countries) do
      node(:iso_code) { |ga|
        ga.geographical_area_id
      }
      node(:description) { |ga|
        ga.geographical_area_description.description
      }
    end
  end
end

child(excluded_geographical_areas: :excluded_countries) do
  node(:iso_code) { |ga|
    ga.geographical_area_id
  }
  node(:description) { |ga|
    ga.geographical_area_description.description
  }
end

child(footnotes: :footnotes) do
  attributes :code
  node(:description) { |footnote|
   footnote.footnote_description.description
  }
end

child(additional_code: :additional_code) do
  attributes :code, :description
end
