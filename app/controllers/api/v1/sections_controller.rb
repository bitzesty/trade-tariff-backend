module Api
  module V1
    class SectionsController < ApplicationController
      def index
        @sections = Section.all

        respond_with @sections
      end

      def show
        @section = Section.find(params[:id])

        respond_with @section
      end
    end
  end
end
