module Api
  module V1
    class HeadingsController < ApplicationController
      def show
        respond_with Heading.find(params[:id])
      end
    end
  end
end
