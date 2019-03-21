module Api
  module V1
    module Headings
      class ChapterSerializer
        include FastJsonapi::ObjectSerializer
        set_id :goods_nomenclature_sid
        set_type :chapter
        attributes :goods_nomenclature_item_id, :description, :formatted_description
        attribute :chapter_note, if: Proc.new { |chapter| chapter.chapter_note.present? } do |chapter|
          chapter.chapter_note.content
        end
        has_many :guides, serializer: Api::V1::Headings::GuideSerializer
      end
    end
  end
end