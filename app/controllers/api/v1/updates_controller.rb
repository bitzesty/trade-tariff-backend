module Api
  module V1
    class UpdatesController < ApiController
      def index
        @updates = TariffSynchronizer::BaseUpdate.descending

        respond_with @updates
      end

      def latest
        @updates = TariffSynchronizer::BaseUpdate.latest_applied_of_both_kinds

        respond_with @updates
      end
    end
  end
end
