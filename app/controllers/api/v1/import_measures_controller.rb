module Api
  module V1
    class ImportMeasuresController < ApplicationController
      def index
        @commodity = Commodity.find_by_code(params[:commodity_id])
        @measures = @commodity.measures.includes(ref_measure_type: :measure_type_description)

        respond_with @measures
      end
    end
  end
end
