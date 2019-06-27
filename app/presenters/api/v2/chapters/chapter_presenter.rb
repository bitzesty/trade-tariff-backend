module Api
  module V2
    module Chapters
      class ChapterPresenter
        attr_reader :chapter, :root_headings
        alias headings root_headings

        delegate :goods_nomenclature_sid, :goods_nomenclature_item_id,
                 :description, :formatted_description, :chapter_note, :section,
                 :guides, :section_id, :guide_ids, to: :chapter

        def initialize(chapter, root_headings)
          @chapter = chapter
          @root_headings = root_headings
        end

        def heading_ids
          root_headings.map(&:goods_nomenclature_sid)
        end
      end
    end
  end
end
