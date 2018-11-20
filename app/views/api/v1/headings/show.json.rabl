object @heading
cache @heading_cache_key, expires_at: actual_date.end_of_day

attributes :goods_nomenclature_item_id, :description, :bti_url,
           :formatted_description

  footnotes = @heading.footnotes
  if footnotes.any?
    child(footnotes) {
      attributes :code, :description, :formatted_description
    }
  end

if @heading.declarable?
  attributes :basic_duty_rate

  extends "api/v1/declarables/declarable", object: @heading, locals: { measures: @measures }
else
  child :chapter do
    attributes :goods_nomenclature_item_id, :description, :formatted_description
    node(:chapter_note, if: lambda {|chapter| chapter.chapter_note.present? }) do |chapter|
      chapter.chapter_note.content
    end
  end

  child :section do
    attributes :title, :numeral, :position
    node(:section_note, if: lambda { |section| section.section_note.present? }) do |section|
      section.section_note.content
    end
  end

  child(@commodities) {
    attributes :description,
               :number_indents,
               :goods_nomenclature_item_id,
               :leaf,
               :goods_nomenclature_sid,
               :formatted_description,
               :description_plain,
               :producline_suffix

    node(:parent_sid) { |commodity| commodity.parent.try(:goods_nomenclature_sid) }
    node(:overview_measures, if: lambda { |commodity| commodity.declarable? }) { |commodity|
      commodity.overview_measures_indexed.map do |measure|
        partial "api/v1/measures/_measure_short", object: measure
      end
    }
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
