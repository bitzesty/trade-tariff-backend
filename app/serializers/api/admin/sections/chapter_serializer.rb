module Api
  module Admin
    module Sections
      class ChapterSerializer
        include FastJsonapi::ObjectSerializer

        set_type :chapter

        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_sid, :goods_nomenclature_item_id, :headings_from, :headings_to, :description

        attribute :chapter_note_id do |chapter|
          chapter.chapter_note.try(:id)
        end

        attribute :search_references_count do |chapter|
          chapter.search_references.count
        end
      end
    end
  end
end
