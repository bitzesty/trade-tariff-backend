module Api
  module V1
    class CommoditiesController < ApplicationController
      def show
        @commodity = Commodity.includes(:heading).find_by(code: params[:id])

        respond_with @commodity
      end

      def import_measures
        commodity = Commodity.includes(:measures).find_by(code: params[:id])
        @measures = commodity.measures.for_import
        @measures = [commodity.measures.for_import.ergo_omnes, commodity.measures.for_import.specific]
        respond_with @measures
      end

      def export_measures
        commodity = Commodity.includes(:measures).find_by(code: params[:id])
        @measures = [commodity.measures.for_export.ergo_omnes, commodity.measures.for_export.specific]
        respond_with @measures
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
