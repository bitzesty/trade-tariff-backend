module Api
  module V2
    module Headings
      class ChapterSerializer
        include FastJsonapi::ObjectSerializer

        set_type :chapter

        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_item_id, :description, :formatted_description, :chapter_note

        has_many :guides, serializer: Api::V2::GuideSerializer
      end
    end
  end
end
