module Api
  module V1
    class ChaptersController < ApplicationController
      def show
        @chapter = Chapter.actual
                          .where(goods_nomenclature_item_id: "#{params[:id]}00000000")
                          .first

        respond_with @chapter
      end
    end
  end
end
