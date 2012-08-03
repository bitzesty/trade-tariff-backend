require 'goods_nomenclature_mapper'

module Api
  module V1
    class ChaptersController < ApplicationController
      def show
        @chapter = Chapter.actual
                          .where(goods_nomenclature_item_id: chapter_id)
                          .take

        @headings = GoodsNomenclatureMapper.new(@chapter.headings).root_entries

        respond_with @chapter
      end

      def chapter_id
        "#{params[:id]}00000000"
      end
    end
  end
end
