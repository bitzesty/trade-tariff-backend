module Api
  module V1
    class SectionsController < ApplicationController
      def index
        respond_with Section.all
      end

      def show
        @section = Section.find(params[:id])

        respond_with @section
      end
    end
  end
end
