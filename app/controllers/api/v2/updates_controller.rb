module Api
  module V2
    class UpdatesController < ApiController
      before_action :collection, only: :index

      def index
        render json: Api::V2::UpdateSerializer.new(@collection.to_a, pagination_links).serializable_hash
      end

      def latest
        @updates = TariffSynchronizer::BaseUpdate.latest_applied_of_both_kinds

        render json: Api::V2::UpdateSerializer.new(@updates.to_a).serializable_hash
      end

      private

      def collection
        @collection ||= TariffSynchronizer::BaseUpdate.eager(:conformance_errors, :presence_errors)
                                                      .descending
                                                      .paginate(current_page, per_page)
      end

      def per_page
        60
      end

      def pagination_links
        {
          links: {
            first: api_updates_path(per_page: per_page),
            self: api_updates_path(page: current_page, per_page: per_page),
            last: api_updates_path(page: @collection.page_count, per_page: per_page)
          }
        }
      end
    end
  end
end
