module Api
  module V1
    class SectionsController < ApplicationController
      def index
        @sections = Section.all

        respond_with @sections
      end

      def show
        @section = Section.includes(chapters: :goods_nomenclature_descriptions).where(["sections.position = ? AND goods_nomenclature_description_periods.validity_start_date <= ? AND (goods_nomenclature_description_periods.validity_end_date >= ? OR goods_nomenclature_description_periods.validity_end_date IS NULL)", params[:id], as_of, as_of]).first

        respond_with @section
      end
    end
  end
end
