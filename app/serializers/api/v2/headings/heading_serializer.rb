module Api
  module V2
    module Headings
      class HeadingSerializer
        include FastJsonapi::ObjectSerializer

        set_type :heading

        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_item_id, :description, :bti_url, :formatted_description

        attribute :search_references_count do |object|
          # after adding ES caching serialized objects are no longer Sequel::Model instances
          SearchReference.where(referenced_id: object.id.to_s, referenced_class: 'Heading').count
        end

        has_many :footnotes, serializer: Api::V2::Headings::FootnoteSerializer
        has_one :section, serializer: Api::V2::Headings::SectionSerializer
        has_one :chapter, serializer: Api::V2::Headings::ChapterSerializer
        has_many :commodities, serializer: Api::V2::Headings::CommoditySerializer
      end
    end
  end
end
