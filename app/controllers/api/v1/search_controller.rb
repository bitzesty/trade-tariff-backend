module Api
  module V1
    class SearchController < ApplicationController
      def search
        render json: SearchService.new(params).perform!
      end
    end
  end
end
