module Api
  module V1
    class SearchController < ApplicationController
      def search
        render json: Search.new(params).perform.as_json
      end
    end
  end
end
