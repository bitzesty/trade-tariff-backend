module Api
  module V1
    class SectionsController < ApiController
      def index
        @sections = Section.eager({ chapters: [:chapter_note] }, :section_note).all

        render json: SectionListSerializer.new(@sections).serializable_hash
      end

      def show
        # id is a position
        @section = Section.where(position: params[:id])
                          .take
        options = {}
        options[:include] = [:chapters, 'chapters.guides']
        render json: SectionSerializer.new(@section, options).serializable_hash
      end

    end
  end
end
