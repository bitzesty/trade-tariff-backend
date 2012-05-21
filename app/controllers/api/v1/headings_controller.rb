module Api
  module V1
    class HeadingsController < ApplicationController
      def index
        respond_with Heading.all
      end
    end
  end
end
