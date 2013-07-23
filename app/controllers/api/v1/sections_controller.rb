module Api
  module V1
    class SectionsController < ApplicationController
      def index
        @sections = Section.eager(:chapters).all

        respond_with @sections
      end

      def show
        @section = Section.where(position: params[:id])
                          .take

        respond_with @section
      end
    end
  end
end
