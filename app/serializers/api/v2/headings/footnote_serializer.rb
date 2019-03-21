module Api
  module V2
    module Headings
      class FootnoteSerializer
        include FastJsonapi::ObjectSerializer
        set_id :footnote_id
        set_type :footnote
        attributes :code, :description, :formatted_description
      end
    end
  end
end