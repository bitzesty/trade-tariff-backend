module Api
  module V1
    class SearchController < ApiController
      def search
        render json: SearchService.new(params)
      end

      def suggestions
        render json: SuggestionsService.new
      end
    end
  end
end
