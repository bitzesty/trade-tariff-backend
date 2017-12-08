attributes :id,
           :origin,
           :effective_start_date,
           :effective_end_date,
           :import

node(:excise) { |measure| measure.excise? }
node(:vat)    { |measure| measure.vat? }

node(:measure_type) { |measure|
  {
    id: measure.measure_type_id,
    description: measure.measure_type.description
  }
}
node(:duty_expression) { |measure|
  {
    base: measure.duty_expression_with_national_measurement_units_for(locals[:declarable]),
    formatted_base: measure.formatted_duty_expression_with_national_measurement_units_for(locals[:declarable])
  }
}

node(:legal_act, if: ->(measure) { !measure.national && measure.generating_regulation_present? }) do |measure|
  {
    generating_regulation_code: measure.generating_regulation_code,
    url: measure.generating_regulation_url,
    suspended: measure.suspended?,
    validity_end_date: measure.generating_regulation.validity_end_date,
    validity_start_date: measure.generating_regulation.validity_start_date,
    officialjournal_number: measure.generating_regulation.officialjournal_number,
    officialjournal_page: measure.generating_regulation.officialjournal_page,
    published_date: measure.generating_regulation.published_date
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

child(:measure_conditions) do
  attributes :condition, :document_code, :requirement, :action, :duty_expression
end

if locals[:geo_areas]
  node(:geographical_area) do |measure|
    {
      id: locals[:geo_areas].select{ |g| g.geographical_area_sid == measure.geographical_area_sid }.last.id,
      description: locals[:geo_areas].select{ |g| g.geographical_area_sid == measure.geographical_area_sid }.last.description,
      children_geographical_areas: locals[:geo_areas].select{ |g| g.geographical_area_sid == measure.geographical_area_sid }.last.contained_geographical_areas.map{|c| {id: c.id, description: c.description} }
    }
  end
else
  child(:geographical_area) do
    attributes :id, :description

    child(contained_geographical_areas: :children_geographical_areas) do
      attributes :id, :description
    end
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
  attributes :code, :description, :formatted_description
end

node(:additional_code, if: ->(measure) { measure.additional_code.present? }) do |measure|
  {
    code: measure.additional_code.code,
    description: measure.additional_code.description,
    formatted_description: measure.additional_code.formatted_description
  }
end

node(:additional_code, if: ->(measure) { measure.export_refund_nomenclature_sid.present? }) do |measure|
  {
    code: measure.export_refund_nomenclature.additional_code,
    description: measure.export_refund_nomenclature.description
  }
end

child(order_number: :order_number) do
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
