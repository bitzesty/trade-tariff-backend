module Api
  module V2
    module Sections
      class SectionListSerializer
        include FastJsonapi::ObjectSerializer

        set_type :section

        set_id :id

        attributes :id, :numeral, :title, :position, :chapter_from, :chapter_to

        attribute :section_note_id do |section|
          section.section_note&.id
        end

        attribute :search_references_count do |section|
          section.search_references.count
        end
      end
    end
  end
end
