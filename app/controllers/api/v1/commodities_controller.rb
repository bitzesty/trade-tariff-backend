module Api
  module V1
    class CommoditiesController < ApplicationController
      def show
        @commodity = Commodity.find(params[:id])

        respond_with @commodity
      end
    end
  end
end
