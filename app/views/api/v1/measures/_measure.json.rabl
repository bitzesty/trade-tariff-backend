attributes :origin

node(:measure_type_description) { |obj|
  obj.measure_type_description.description
}

node(:legal_act, if: ->(measure) { measure.generating_regulation_present? }) do |obj|
  {
    generating_regulation_code: obj.generating_regulation_code,
    url: obj.generating_regulation_url
  }
end

child(measure_components: :measure_components) do
  attributes :duty_amount, :duty_expression_id

  node(:monetary_unit) { |component|
    component.monetary_unit_code
  }
  node(:measurement_unit) { |component|
    component.measurement_unit.try(:description)
  }
  node(:measurement_unit_qualifier) { |component|
    component.measurement_unit_qualifier.try(:description)
  }
end

child(measure_conditions: :measure_conditions) do
  attributes :document_code, :requirement_type, :requirement, :action, :condition

  child(measure_condition_components: :components) do
    attributes :duty_amount, :duty_expression_id

    node(:monetary_unit) { |component|
      component.monetary_unit_code
    }
    node(:measurement_unit) { |component|
      component.measurement_unit.try(:description)
    }
    node(:measurement_unit_qualifier) { |component|
      component.measurement_unit_qualifier.try(:description)
    }
  end
end

child(geographical_area: :geographical_area) do
  attributes :iso_code

  node(:description) { |ga|
    ga.geographical_area_description.description
  }
  node(:children_geographical_areas, if: ->(region) { region.contained_geographical_areas.any? }) do |region|
    child(contained_geographical_areas: :children_geographical_areas) do
      attributes :iso_code

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

child(quota_order_number: :order_number) do
  node(:number) { |qon| qon.quota_order_number_id }

  child(quota_definition: :definition) do
    attributes :initial_volume, :validity_start_date, :validity_end_date, :status

    node(:measurement_unit) { |qd| qd.measurement_unit_code }
    node(:monetary_unit) { |qd| qd.monetary_unit_code }
    node(:measurement_unit_qualifier ) { |qd| qd.measurement_unit_qualifier_code }
    node(:balance) { |qd| qd.last_balance_event.try(:new_balance)  }
    node(:last_allocation_date) { |qd| qd.last_balance_event.try(:occurrence_timestamp) }
    node(:suspension_period_start_date) { |qd| qd.last_suspension_period.try(:suspension_start_date) }
    node(:suspension_period_end_date) { |qd| qd.last_suspension_period.try(:suspension_end_date) }
    node(:blocking_period_start_date) { |qd| qd.last_blocking_period.try(:blocking_start_date) }
    node(:blocking_period_end_date) { |qd| qd.last_blocking_period.try(:blocking_end_date) }
  end
end

