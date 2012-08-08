module Api
  module V1
    class SectionsController < ApplicationController
      def index
        @sections = Section.all

        respond_with @sections
      end

      def show
        @section = Section.eager(chapters: :goods_nomenclature_description)
                          .where(position: params[:id])
                          .all
                          .first

        respond_with @section
      end
    end
  end
end
