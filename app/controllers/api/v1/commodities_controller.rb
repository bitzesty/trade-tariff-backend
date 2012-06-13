module Api
  module V1
    class CommoditiesController < ApplicationController

      before_filter :restrict_access, only: [:update]

      def show
        @commodity = Commodity.includes(:heading).find_by(code: params[:id])

        respond_with @commodity
      end

      # TODO: Remove this hack once the write api is done.
      def update
        @commodity = Commodity.find_by(code: params[:id])
        @commodity.synonyms = params[:commodity][:synonyms]
        @commodity.save

        respond_with @commodity
      end
    end
  end
end
