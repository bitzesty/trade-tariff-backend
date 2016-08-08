object @heading
cache @heading_cache_key, expires_at: actual_date.end_of_day

attributes :goods_nomenclature_item_id, :description, :bti_url,
           :formatted_description

if @heading.declarable?
  attributes :basic_duty_rate

  extends "api/v1/declarables/declarable", object: @heading, locals: { measures: @measures }
else
  child :chapter do
    attributes :goods_nomenclature_item_id, :description, :formatted_description
  end

  child :section do
    attributes :title, :numeral, :position
  end

  child(@commodities) {
    attributes :description,
               :number_indents,
               :goods_nomenclature_item_id,
               :leaf,
               :goods_nomenclature_sid,
               :formatted_description,
               :description_plain

    node(:parent_sid) { |commodity| commodity.parent.try(:goods_nomenclature_sid) }
  }
end

node(:_response_info) do
  {
    links: [
      { rel: 'self', href: api_link(request.fullpath) },
      { rel: 'chapter', href: api_link(api_chapter_path(@heading.chapter)) },
      { rel: 'section', href: api_link(api_section_path(@heading.section)) }
    ]
  }
end
