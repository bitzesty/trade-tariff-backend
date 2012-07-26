require 'commodity_mapper'

module Api
  module V1
    class HeadingsController < ApplicationController
      def show
        @heading = Heading.actual
                          .where(goods_nomenclatures__goods_nomenclature_item_id: heading_id)
                          .first

        @commodities = CommodityMapper.new(@heading.commodities).commodities

        respond_with @heading
      end

      def heading_id
        "#{params[:id]}000000"
      end
    end
  end
end
