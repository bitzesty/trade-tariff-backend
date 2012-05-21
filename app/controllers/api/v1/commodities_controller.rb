module Api
  module V1
    class CommoditiesController < ApplicationController
      def show
        respond_with Commodity.find(params[:id])
      end
    end
  end
end
