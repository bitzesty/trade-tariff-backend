object @commodity
cache @commodity_cache_key, expires_at: actual_date.end_of_day

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

node(:_response_info) do
  {
    links: [
      { rel: 'self', href: api_link(request.fullpath) },
      { rel: 'heading', href: api_link(api_heading_path(@commodity.heading)) },
      { rel: 'chapter', href: api_link(api_chapter_path(@commodity.chapter)) },
      { rel: 'section', href: api_link(api_section_path(@commodity.section)) }
    ]
  }
end
