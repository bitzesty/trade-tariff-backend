module Api
  module V2
    class QuotasController < ApiController
      def search
        TimeMachine.now do
          quotas = QuotaSearchService.new(params).perform
          options = {}
          options[:include] = [:quota_order_number, 'quota_order_number.geographical_areas', :measures, 'measures.geographical_area']
          render json: Api::V2::Quotas::Definition::QuotaDefinitionSerializer.new(quotas, options).serializable_hash
        end
      end
    end
  end
end
