module Api
  module V1
    class ImportMeasuresController < ApplicationController
      def index
        @commodity = Commodity.by_code(params[:commodity_id]).first
        @measures = @commodity.measures

        respond_with @measures
      end
    end
  end
end
