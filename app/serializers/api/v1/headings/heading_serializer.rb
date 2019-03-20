module Api
  module V1
    module Headings
      class HeadingSerializer
        include FastJsonapi::ObjectSerializer
        set_id :goods_nomenclature_sid
        set_type :heading

        attributes :goods_nomenclature_item_id, :description, :bti_url,
                   :formatted_description

        has_many :footnotes, serializer: Api::V1::Headings::FootnoteSerializer
        has_one :section, serializer: Api::V1::Headings::SectionSerializer
        has_one :chapter, serializer: Api::V1::Headings::ChapterSerializer
        has_many :commodities, serializer: Api::V1::Headings::CommoditySerializer

      end
    end
  end
end