module Api
  module V2
    class AdditionalCodesController < ApiController
      before_action :find_additional_codes
      before_action :find_measures, only: [:search_measures, :search_goods_nomenclatures]
      before_action :find_goods_nomenclatures, only: :search_goods_nomenclatures

      def search
        render json: Api::V2::AdditionalCodeSerializer.new(@additional_codes, {}).serializable_hash
      end

      def search_measures
        render json: Api::V2::Measures::ShortMeasureSerializer.new(@measures, {}).serializable_hash
      end

      def search_goods_nomenclatures
        render json: Api::V2::GoodsNomenclatures::GoodsNomenclatureListSerializer.new(@goods_nomenclatures).serializable_hash
      end

      private

      def find_additional_codes
        TimeMachine.now do
          @additional_codes = AdditionalCodeSearchService.new(params).perform
        end
      end

      def find_measures
        @measures = @additional_codes.map(&:measure)
      end

      def find_goods_nomenclatures
        @goods_nomenclatures = @measures.map(&:goods_nomenclature)
      end
    end
  end
end
