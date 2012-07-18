module Api
  module V1
    class ImportMeasuresController < ApplicationController
      def index
        @commodity = Commodity.by_code(params[:commodity_id]).first
        @measures = @commodity.import_measures

        respond_with @measures
      end
    end
  end
end
