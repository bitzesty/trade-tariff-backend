module Api
  module V2
    module Footnotes
      class FootnoteSerializer
        include JSONAPI::Serializer

        set_type :footnote

        set_id :code

        attributes :code, :footnote_type_id, :footnote_id, :description, :formatted_description, :extra_large_measures

        has_many :measures, serializer: Api::V2::Footnotes::MeasureSerializer

        has_many :goods_nomenclatures, serializer: Api::V2::Footnotes::GoodsNomenclatureSerializer
      end
    end
  end
end
