module Api
  module V1
    module Sections
      class ChapterSerializer
        include FastJsonapi::ObjectSerializer
        set_id :goods_nomenclature_sid
        set_type :chapter
        attributes :goods_nomenclature_sid, :goods_nomenclature_item_id, :headings_from, :headings_to, :description, :formatted_description

        attribute :chapter_note_id do |chapter|
          chapter.chapter_note.try(:id)
        end

        has_many :guides, serializer: Api::V1::Sections::GuideSerializer

      end
    end
  end
end
