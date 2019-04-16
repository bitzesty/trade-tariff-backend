module Api
  module V2
    class QuotasController < ApiController
      def search
        service = QuotaSearchService.new(params)
        TimeMachine.at(service.as_of || Date.current) do
          quotas = service.perform
          options = {}
          options[:include] = [:definition, :geographical_area]
          render json: Api::V2::Quotas::QuotaOrderNumberSerializer.new(quotas, options).serializable_hash
        end
      end
    end
  end
end