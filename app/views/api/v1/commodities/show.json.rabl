object @commodity

attributes :producline_suffix, :description, :number_indents,
           :goods_nomenclature_item_id, :bti_url, :formatted_description,
           :description_plain, :consigned, :consigned_from, :basic_duty_rate

extends "api/v1/declarables/declarable", object: @commodity, locals: { measures: @measures }

child @commodity.heading do
  attributes :goods_nomenclature_item_id, :description, :formatted_description,
             :description_plain
end

child(@commodity.ancestors => :ancestors) {
    attributes :producline_suffix,
               :description,
               :number_indents,
               :goods_nomenclature_item_id,
               :leaf,
               :uk_vat_rate,
               :formatted_description,
               :description_plain
}
