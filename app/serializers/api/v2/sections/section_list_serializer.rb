module Api
  module V2
    module Sections
      class SectionListSerializer
        include FastJsonapi::ObjectSerializer
        set_type :section
        attributes :id, :numeral, :title, :position, :chapter_from, :chapter_to
        attribute :section_note_id do |section|
          section.section_note&.id
        end
      end
    end
  end
end