module Api
  module V2
    module Sections
      class ChapterSerializer
        include FastJsonapi::ObjectSerializer

        set_type :chapter

        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_sid, :goods_nomenclature_item_id, :headings_from, :headings_to, :description, :formatted_description

        attribute :chapter_note_id do |chapter|
          chapter.chapter_note.try(:id)
        end

        has_many :guides, serializer: Api::V2::GuideSerializer
      end
    end
  end
end
