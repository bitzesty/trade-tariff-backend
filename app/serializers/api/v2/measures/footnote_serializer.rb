module Api
  module V2
    module Measures
      class FootnoteSerializer
        include JSONAPI::Serializer

        set_type :footnote

        set_id :code

        attributes :code, :description, :formatted_description
      end
    end
  end
end
