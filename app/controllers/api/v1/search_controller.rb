module Api
  module V1
    class SearchController < ApiController
      def search
        render json: SearchService.new(params)
      end
    end
  end
end
