module Api
  module V1
    class MeasuresController < ApplicationController
      before_filter :restrict_access

      def create
        @measure = Measure.new(params[:measure])
        @measure.save

        respond_with @measure
      end

      def update
        @measure = Measure.find_by(identifier: params[:id])
        @measure.update_attributes(params[:measure])

        respond_with @measure
      end

      def delete
        @measure = Measure.find_by(identifier: params[:id])
        @measure.destroy

        respond_with @measure
      end

    end
  end
end
