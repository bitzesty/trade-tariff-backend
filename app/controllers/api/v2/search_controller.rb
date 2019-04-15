module Api
  module V2
    class SearchController < ApiController
      def search
        render json: SearchService.new(
          Api::V2::SearchSerializationService.new,
          Api::V2::ErrorSerializationService.new,
          params).to_json
      end

      def suggestions
        suggestions = Api::V2::SuggestionsService.new.perform
        render json: Api::V2::SearchSuggestionSerializer.new(suggestions).serializable_hash
      end
      
      def quota_search
        service = QuotaSearchService.new(params)
        TimeMachine.at(service.as_of || Date.current) do
          quotas = service.perform
          options = {}
          options[:include] = [:definition]
          render json: Api::V2::Quotas::QuotaOrderNumberSerializer.new(quotas, options).serializable_hash
        end
      end
    end
  end
end
