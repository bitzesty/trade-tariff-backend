module Api
  module V1
    class SearchController < ApplicationController
      def search
        respond_with Search.new(params).perform
      end
    end
  end
end
