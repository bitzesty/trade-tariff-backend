module Api
  module Admin
    module Chapters
      class SectionSerializer
        include FastJsonapi::ObjectSerializer

        set_type :section

        set_id :id

        attributes :id, :numeral, :title, :position

        has_one :section_note, serializer: Api::Admin::Sections::SectionNoteSerializer, id_method_name: :id do |section|
          section.section_note
        end
      end
    end
  end
end
