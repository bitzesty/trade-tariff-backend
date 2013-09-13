require 'goods_nomenclature_mapper'

module Api
  module V1
    class ChaptersController < ApiController
      before_filter :find_chapter, only: [:show, :changes]

      def index
        @chapters = Chapter.eager(:chapter_note).all

        respond_with @chapters
      end

      def show
        @headings = GoodsNomenclatureMapper.new(@chapter.headings_dataset
                                                        .eager(:goods_nomenclature_descriptions,
                                                               :goods_nomenclature_indents)
                                                        .all).root_entries

        respond_with @chapter
      end

      def changes
        @changes = @chapter.changes

        render 'api/v1/changes/changes'
      end

      private

      def find_chapter
        @chapter = Chapter.actual
                          .where(goods_nomenclature_item_id: chapter_id)
                          .take

        raise Sequel::RecordNotFound if @chapter.goods_nomenclature_item_id.in? HiddenGoodsNomenclature.codes
      end

      def chapter_id
        "#{params[:id]}00000000"
      end
    end
  end
end
