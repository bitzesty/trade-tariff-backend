module Api
  module V2
    module Chapters
      class ChapterPresenter

        attr_reader :chapter, :headings_presenter
        alias :headings :headings_presenter

        delegate :goods_nomenclature_sid, :goods_nomenclature_item_id,
                 :description, :formatted_description, :chapter_note, :section,
                 :guides, :section_id, :guide_ids, :heading_ids, to: :chapter

        def initialize(chapter, headings_presenter)
          @chapter = chapter
          @headings_presenter = headings_presenter
        end

      end
    end
  end
end
