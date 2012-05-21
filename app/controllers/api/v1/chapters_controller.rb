module Api
  module V1
    class ChaptersController < ApplicationController
      def index
        respond_with Chapter.all
      end
    end
  end
end
