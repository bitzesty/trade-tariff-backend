require 'commodity_mapper'

module Api
  module V1
    class CommoditiesController < ApplicationController

      before_filter :restrict_access, only: [:update]

      def show
        @heading = Heading.where
                          .where("goods_nomenclatures.goods_nomenclature_item_id = ?", "#{params[:id].first(4)}000000")
                          .first

        @commodity = CommodityMapper.new(@heading.commodities).detect{|commodity| commodity.goods_nomenclature_item_id == params[:id].first(10) && commodity.producline_suffix == params[:id].last(2) }

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
