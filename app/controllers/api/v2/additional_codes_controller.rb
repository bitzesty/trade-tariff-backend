module Api
  module V2
    class AdditionalCodesController < ApiController
      before_action :find_additional_codes

      def search
        options = {}
        options[:include] = [:measures, 'measures.goods_nomenclature']
        render json: Api::V2::AdditionalCodes::AdditionalCodeSerializer.new(@additional_codes, options).serializable_hash
      end

      private

      def find_additional_codes
        TimeMachine.now do
          @additional_codes = AdditionalCodeSearchService.new(params).perform
        end
      end
    end
  end
end
