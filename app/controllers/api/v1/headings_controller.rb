module Api
  module V1
    class HeadingsController < ApplicationController
      def show
        @heading = Heading.includes(:commodities, :chapter).find_by(short_code: params[:id])

        respond_with @heading
      end

      def import_measures
        heading = Heading.find_by(code: params[:id])
        @measures = heading.measures.for_import
        @measures = [heading.measures.for_import.ergo_omnes, heading.measures.for_import.specific]
        respond_with @measures
      end

      def export_measures
        heading = Heading.find_by(code: params[:id])
        @measures = [heading.measures.for_export.ergo_omnes, heading.measures.for_export.specific]
        respond_with @measures
      end
    end
  end
end
