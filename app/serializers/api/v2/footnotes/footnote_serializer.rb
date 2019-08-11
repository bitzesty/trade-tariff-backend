module Api
  module V2
    module Footnotes
      class FootnoteSerializer
        include FastJsonapi::ObjectSerializer

        set_type :footnote

        set_id :code

        attributes :code, :description, :formatted_description

        has_many :measures, serializer: Api::V2::Footnotes::MeasureSerializer

        has_many :goods_nomenclatures, serializer: Api::V2::Footnotes::GoodsNomenclatureSerializer
      end
    end
  end
end
