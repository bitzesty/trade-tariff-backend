module Api
  module V1
    class CommoditiesController < ApplicationController

      before_filter :restrict_access, only: [:update]

      def show
        @commodity = Commodity.actual
                              .declarable
                              .by_code(params[:id])
                              .take

        respond_with @commodity
      end
    end
  end
end
