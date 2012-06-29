module Api
  module V1
    class ExportMeasuresController < ApplicationController
      def index
        @measures = [item.measures.for_export.ergo_omnes, item.measures.for_export.specific]
        respond_with @measures
      end
    end
  end
end
