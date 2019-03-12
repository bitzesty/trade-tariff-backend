module Api
  module V1
    module Chapters
      class ChapterPresenter

        attr_reader :chapter, :headings

        delegate :goods_nomenclature_sid, :goods_nomenclature_item_id,
                 :description, :formatted_description, :chapter_note, :section,
                 :guides, :section_id, :guide_ids, :heading_ids, to: :chapter

        def initialize(chapter, headings)
          @chapter = chapter
          @headings = headings
        end

      end
    end
  end
end
