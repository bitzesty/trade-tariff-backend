module Api
  module V1
    class ChaptersController < ApplicationController
      def show
        respond_with Chapter.find(params[:id])
      end
    end
  end
end
