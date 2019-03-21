module Api
  module V1
    module Chapters
      class SectionSerializer
        include FastJsonapi::ObjectSerializer
        attributes :id, :numeral, :title, :position
        set_type :section
        attribute :section_note, if: Proc.new { |section| section.section_note.present? } do |section|
          section.section_note.content
        end
      end
    end
  end
end
