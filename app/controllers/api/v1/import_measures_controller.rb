module Api
  module V1
    class ImportMeasuresController < ApplicationController
      def index
        @measures = [item.measures.for_import.ergo_omnes, item.measures.for_import.specific]
        respond_with @measures
      end
    end
  end
end
