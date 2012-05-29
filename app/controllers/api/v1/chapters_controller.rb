module Api
  module V1
    class ChaptersController < ApplicationController
      def show
        @chapter = Chapter.includes(:headings, :section).find_by(short_code: params[:id])

        respond_with @chapter
      end
    end
  end
end
