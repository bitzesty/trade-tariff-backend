require 'commodity_mapper'

module Api
  module V1
    class HeadingsController < ApplicationController
      def show
        @heading = Heading.includes(:goods_nomenclature_descriptions)
                          .where(["goods_nomenclature_description_periods.validity_start_date <= ? AND (goods_nomenclature_description_periods.validity_end_date >= ? OR goods_nomenclature_description_periods.validity_end_date IS NULL)", as_of, as_of])
                          .where("goods_nomenclatures.goods_nomenclature_item_id = ?", "#{params[:id]}000000")
                          .first

        @commodities = CommodityMapper.new(Commodity.includes(:goods_nomenclature_descriptions, :goods_nomenclature_indent)
                                                    .where(["(goods_nomenclatures.validity_start_date <= ? AND (goods_nomenclatures.validity_end_date >= ? OR goods_nomenclatures.validity_end_date IS NULL)) AND (goods_nomenclature_description_periods.validity_start_date <= ? AND (goods_nomenclature_description_periods.validity_end_date >= ? OR goods_nomenclature_description_periods.validity_end_date IS NULL))", as_of, as_of, as_of, as_of])
                                                    .where("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", @heading.heading_id)
                                                    .order("goods_nomenclatures.goods_nomenclature_item_id, producline_suffix")).commodities

        respond_with @heading
      end
    end
  end
end
