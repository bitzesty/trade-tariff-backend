module Api
  module V2
    module Footnotes
      class FootnoteTypeSerializer
        include FastJsonapi::ObjectSerializer

        set_type :footnote_type

        set_id :footnote_type_id

        attributes :footnote_type_id, :description
      end
    end
  end
end