attributes :producline_suffix, :description, :number_indents, :goods_nomenclature_item_id,
           :leaf, :uk_vat_rate

child(third_country_duty: :basic_duty_rate_components) do
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

