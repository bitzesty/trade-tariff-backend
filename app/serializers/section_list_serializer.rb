class SectionListSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :numeral, :title, :position, :chapter_from, :chapter_to
  attribute :section_note_id do |section|
    section.section_note&.id
  end
end