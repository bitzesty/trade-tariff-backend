module Api
  module V1
    class ChaptersController < ApplicationController
      def show
        @chapter = Chapter.includes(:goods_nomenclature_descriptions)
                          .where(["goods_nomenclature_description_periods.validity_start_date <= ? AND (goods_nomenclature_description_periods.validity_end_date >= ? OR goods_nomenclature_description_periods.validity_end_date IS NULL)", as_of, as_of])
                          .where(["goods_nomenclatures.goods_nomenclature_item_id = ?", "#{params[:id]}00000000"])
                          .first

        respond_with @chapter
      end
    end
  end
end
