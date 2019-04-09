module Api
  module V1
    class SearchController < ApiController
      def search
        render json: SearchService.new(params)
      end

      def suggestions
        render json: Api::V1::SuggestionsService.new
      end
    end
  end
end
