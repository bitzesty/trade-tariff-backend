module Api
  module V2
    module Measures
      class FootnoteSerializer
        include FastJsonapi::ObjectSerializer
        set_id :code
        set_type :footnote
        attributes :code, :description, :formatted_description
      end
    end
  end
end