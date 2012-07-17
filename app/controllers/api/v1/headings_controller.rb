require 'commodity_mapper'

module Api
  module V1
    class HeadingsController < ApplicationController
      def show
        @heading = Heading.actual
                          .where("goods_nomenclatures.goods_nomenclature_item_id = ?", "#{params[:id]}000000")
                          .first

        @commodities = CommodityMapper.new(@heading.commodities).commodities

        respond_with @heading
      end
    end
  end
end
