module Api
  module V1
    class CommoditiesController < ApplicationController

      before_filter :restrict_access, only: [:update]

      def show
        @commodity = Commodity.includes(:goods_nomenclature_descriptions, :goods_nomenclature_indent)
                              .where(["(goods_nomenclatures.validity_start_date <= ? AND (goods_nomenclatures.validity_end_date >= ? OR goods_nomenclatures.validity_end_date IS NULL)) AND (goods_nomenclature_description_periods.validity_start_date <= ? AND (goods_nomenclature_description_periods.validity_end_date >= ? OR goods_nomenclature_description_periods.validity_end_date IS NULL))", as_of, as_of, as_of, as_of])
                              .where("goods_nomenclatures.goods_nomenclature_item_id = ? AND goods_nomenclatures.producline_suffix = ?", params[:id].first(10), params[:id].last(2))
                              .order("goods_nomenclatures.goods_nomenclature_item_id, producline_suffix")
                              .first.extend(CommodityMapper::MappedCommodity)

        respond_with @commodity
      end

      # TODO: Remove this hack once the write api is done.
      def update
        @commodity = Commodity.find_by(code: params[:id])
        @commodity.synonyms = params[:commodity][:synonyms]
        @commodity.save

        respond_with @commodity
      end
    end
  end
end
