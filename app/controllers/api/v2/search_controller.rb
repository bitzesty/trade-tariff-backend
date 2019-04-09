module Api
  module V2
    class SearchController < ApiController
      def search
        render json: SearchService.new(params)
      end

      def suggestions
        suggestions = Api::V2::SuggestionsService.new.perform
        render json: Api::V2::SearchSuggestionSerializer.new(suggestions).serializable_hash
      end
    end
  end
end
