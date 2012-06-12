require 'item_expose'

module Api
  module V1
    class ExportMeasuresController < ApplicationController
      include Controllers::ItemExpose

      def index
        @measures = [item.measures.for_export.ergo_omnes, item.measures.for_export.specific]
        respond_with @measures
      end
    end
  end
end
