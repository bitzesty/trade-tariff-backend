module Api
  module V1
    class ExportMeasuresController < ApplicationController
      def index
        @commodity = Commodity.by_code(params[:commodity_id]).first
        @measures = @commodity.export_measures

        respond_with @measures
      end
    end
  end
end
