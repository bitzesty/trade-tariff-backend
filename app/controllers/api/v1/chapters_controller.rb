module Api
  module V1
    class ChaptersController < ApplicationController
      def show
        @chapter = Chapter.find(params[:id])

        respond_with @chapter
      end
    end
  end
end
