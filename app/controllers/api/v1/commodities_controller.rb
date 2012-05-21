module Api
  module V1
    class CommoditiesController < ApplicationController
      def index
        respond_with Commodity.all
      end
    end
  end
end
