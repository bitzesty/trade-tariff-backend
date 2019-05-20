module Api
  module V2
    module Headings
      class SectionSerializer
        include FastJsonapi::ObjectSerializer

        set_type :section

        set_id :id

        attributes :numeral, :title, :position, :section_note
      end
    end
  end
end
