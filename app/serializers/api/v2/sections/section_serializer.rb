module Api
  module V2
    module Sections
      class SectionSerializer
        include FastJsonapi::ObjectSerializer

        set_type :section

        set_id :id

        attributes :id, :numeral, :title, :position, :chapter_from, :chapter_to

        attribute :section_note, if: Proc.new { |section| section.section_note.present? } do |section|
          section.section_note.content
        end

        attribute :search_references_count do |section|
          section.search_references.count
        end

        has_many :chapters, serializer: Api::V2::Sections::ChapterSerializer
      end
    end
  end
end
