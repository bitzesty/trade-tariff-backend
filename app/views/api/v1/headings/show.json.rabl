object @heading

attributes :goods_nomenclature_item_id, :description, :bti_url

if @heading.declarable?
  extends "api/v1/declarables/declarable", object: @heading

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
else
  child :chapter do
    attributes :goods_nomenclature_item_id, :description
  end

  child :section do
    attributes :title, :numeral, :position
  end

  child(@commodities) {
    attributes :producline_suffix,
               :description,
               :number_indents,
               :goods_nomenclature_item_id,
               :leaf,
               :uk_vat_rate,
               :goods_nomenclature_sid

    node(:parent_sid) { |commodity| commodity.parent.try(:goods_nomenclature_sid) }
  }
end
