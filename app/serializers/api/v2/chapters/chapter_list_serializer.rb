module Api
  module V1
    module Chapters
      class ChapterListSerializer
        include FastJsonapi::ObjectSerializer
        set_id :goods_nomenclature_sid
        set_type :chapter
        attributes :goods_nomenclature_sid, :goods_nomenclature_item_id

        attribute :chapter_note_id do |chapter|
          chapter.chapter_note.try(:id)
        end
      end
    end
  end
end