module Api
  module V1
    module Headings
      class SectionSerializer
        include FastJsonapi::ObjectSerializer
        set_type :section
        attributes :numeral, :title, :position
        attribute :section_note, if: Proc.new { |section| section.section_note.present? } do |section|
          section.section_note.content
        end
      end
    end
  end
end