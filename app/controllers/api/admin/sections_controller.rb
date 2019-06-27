module Api
  module Admin
    class SectionsController < ApiController
      def index
        @sections = Section.eager(:search_references, { chapters: [:chapter_note] }, :section_note).all

        render json: Api::Admin::Sections::SectionListSerializer.new(@sections).serializable_hash
      end

      def show
        # id is a position
        @section = Section.where(position: params[:id]).take

        options = {}
        options[:include] = [:chapters, :section_note]
        render json: Api::Admin::Sections::SectionSerializer.new(@section, options).serializable_hash
      end
    end
  end
end
