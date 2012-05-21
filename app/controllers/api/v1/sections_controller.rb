module Api
  module V1
    class SectionsController < ApplicationController
      def index
        respond_with Section.all
      end

      def show
        respond_with Section.find(params[:id])
      end
    end
  end
end
