module Api
  module Admin
    class CommoditiesController < ApiController
      before_action :find_commodity, only: [:show]

      def show
        render json: Api::Admin::Commodities::CommoditySerializer.new(@commodity, { is_collection: false }).serializable_hash
      end

      private

      def find_commodity
        @commodity = self.find_commodity_by_code(params[:id])

        raise Sequel::RecordNotFound if @commodity.goods_nomenclature_item_id.in? HiddenGoodsNomenclature.codes
      end

      def self.find_commodity_by_code(code)
        Commodity.actual
                 .declarable
                 .by_code(code)
                 .take
      end
    end
  end
end
