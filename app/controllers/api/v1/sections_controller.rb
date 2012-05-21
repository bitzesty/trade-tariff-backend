module Api
  module V1
    class SectionsController < ApplicationController
      def index
        respond_with Section.all
      end
    end
  end
end
