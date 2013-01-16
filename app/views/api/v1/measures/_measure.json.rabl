attributes :measure_sid,
           :origin,
           :ordernumber,
           :effective_start_date,
           :effective_end_date,
           :measure_type_id,
           :import

node(:measure_type_description) { |obj|
  obj.type.try(:description)
}

node(:legal_act, if: ->(measure) { !measure.national && measure.generating_regulation_present? }) do |measure|
  {
    generating_regulation_code: measure.generating_regulation_code,
    url: measure.generating_regulation_url,
    suspended: measure.suspended?
  }
end

node(:suspension_legal_act, if: ->(measure) { !measure.national && measure.suspended? }) do |measure|
  {
    generating_regulation_code: measure.generating_regulation_code(measure.suspending_regulation.regulation_id),
    url: measure.generating_regulation_url(measure.suspending_regulation.regulation_id),
    validity_end_date: measure.suspending_regulation.effective_end_date,
    validity_start_date: measure.suspending_regulation.effective_start_date
  }
end

child(measure_components: :measure_components) do
  attributes :duty_amount, :duty_expression_id, :duty_expression_description,
             :duty_expression_abbreviation

  node(:monetary_unit) { |component|
    component.monetary_unit_code
  }
  node(:monetary_unit_abbreviation) { |component|
    component.monetary_unit_abbreviation
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
    attributes :duty_amount, :duty_expression_id, :duty_expression_description,
               :duty_expression_abbreviation

    node(:monetary_unit) { |component|
      component.monetary_unit_code
    }
    node(:monetary_unit_abbreviation) { |component|
      component.monetary_unit_abbreviation
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
  attributes :geographical_area_id

  node(:description) { |ga|
    ga.geographical_area_description.description
  }

  child(contained_geographical_areas: :children_geographical_areas) do
    attributes :geographical_area_id

    node(:description) { |ga|
      ga.geographical_area_description.description
    }
  end
end

child(excluded_geographical_areas: :excluded_countries) do
  node(:geographical_area_id) { |ga|
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

node(:additional_code, if: ->(measure) { measure.additional_code.present? }) do |obj|
  {
    code: obj.additional_code.code,
    description: obj.additional_code.description
  }
end

node(:additional_code, if: ->(measure) { measure.export_refund_nomenclature_sid.present? }) do |measure|
  {
    code: measure.export_refund_nomenclature.additional_code,
    description: measure.export_refund_nomenclature.description
  }
end

child(quota_order_number: :order_number) do
  node(:number) { |qon| qon.quota_order_number_id }

  child(quota_definition: :definition) do
    attributes :initial_volume, :validity_start_date, :validity_end_date, :status

    node(:measurement_unit) { |qd| qd.measurement_unit_code }
    node(:monetary_unit) { |qd| qd.monetary_unit_code }
    node(:measurement_unit_qualifier ) { |qd| qd.measurement_unit_qualifier_code }
    node(:balance) { |qd| qd.balance }
    node(:last_allocation_date) { |qd| qd.last_balance_event.try(:occurrence_timestamp) }
    node(:suspension_period_start_date) { |qd| qd.last_suspension_period.try(:suspension_start_date) }
    node(:suspension_period_end_date) { |qd| qd.last_suspension_period.try(:suspension_end_date) }
    node(:blocking_period_start_date) { |qd| qd.last_blocking_period.try(:blocking_start_date) }
    node(:blocking_period_end_date) { |qd| qd.last_blocking_period.try(:blocking_end_date) }
  end
end

