module Api
  module V2
    module Sections
      class SectionListSerializer
        include JSONAPI::Serializer

        set_type :section

        set_id :id

        attributes :id, :numeral, :title, :position, :chapter_from, :chapter_to
      end
    end
  end
end
