module Api
  module V2
    module Footnotes
      class FootnoteSerializer
        include FastJsonapi::ObjectSerializer

        set_type :footnote

        set_id :code

        attributes :code, :description, :formatted_description

        has_many :measures, object_method_name: :valid_measures, serializer: Api::V2::Footnotes::MeasureSerializer
      end
    end
  end
end
