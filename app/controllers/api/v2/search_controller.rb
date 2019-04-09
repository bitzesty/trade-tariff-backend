module Api
  module V2
    class SearchController < ApiController
      def search
        render json: SearchService.new(Api::V2::SearchSerializationService.new, params).to_json
      end

      def suggestions
        suggestions = Api::V2::SuggestionsService.new.perform
        render json: Api::V2::SearchSuggestionSerializer.new(suggestions).serializable_hash
      end
    end
  end
end
