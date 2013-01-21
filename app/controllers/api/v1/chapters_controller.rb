require 'goods_nomenclature_mapper'

module Api
  module V1
    class ChaptersController < ApplicationController
      before_filter :find_chapter, only: [:show]
      def show
        @headings = GoodsNomenclatureMapper.new(@chapter.headings_dataset
                                                        .eager(:goods_nomenclature_description,
                                                               :goods_nomenclature_indent)
                                                        .all).root_entries

        respond_with @chapter
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
