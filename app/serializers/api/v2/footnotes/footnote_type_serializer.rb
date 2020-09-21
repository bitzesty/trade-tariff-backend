module Api
  module V2
    module Footnotes
      class FootnoteTypeSerializer
        include JSONAPI::Serializer

        set_type :footnote_type

        set_id :footnote_type_id

        attributes :footnote_type_id, :description
      end
    end
  end
end
