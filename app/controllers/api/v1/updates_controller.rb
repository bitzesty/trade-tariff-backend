module Api
  module V1
    class UpdatesController < ApplicationController
      def index
        @updates = TariffSynchronizer::BaseUpdate.latest_applied_of_both_kinds

        respond_with @updates
      end
    end
  end
end
