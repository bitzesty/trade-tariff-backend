module Api
  module Admin
    module Chapters
      class SectionSerializer
        include FastJsonapi::ObjectSerializer

        set_type :section

        set_id :id

        attributes :id, :numeral, :title, :position

        has_one :section_note, serializer: Api::Admin::Sections::SectionNoteSerializer
      end
    end
  end
end
