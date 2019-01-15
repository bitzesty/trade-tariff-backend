object @section

attributes :id, :position, :title, :numeral, :chapter_from, :chapter_to

node(:section_note, if: lambda {|section| section.section_note.present? }) do |section|
  section.section_note.content
end

child(chapters: :chapters) do
  attributes :description, :goods_nomenclature_item_id, :goods_nomenclature_sid,
             :headings_from, :headings_to, :formatted_description

  child(:guides, if: lambda {|chapter| chapter.guides.present? }) do
    attributes :title, :url
  end

  node(:chapter_note_id) { |chapter| chapter.chapter_note.try(:id) }
end

node(:_response_info) do
  {
    links: [
      { rel: 'self', href: api_link(request.fullpath) },
      { rel: 'sections', href: api_link(api_sections_path) },
    ]
  }
end
