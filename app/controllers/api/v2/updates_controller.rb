module Api
  module V2
    class UpdatesController < ApiController
      before_action :collection, only: :index

      def index
        render json: Api::V2::TariffUpdateSerializer.new(@collection.to_a, serialization_meta).serializable_hash
      end

      def latest
        @updates = TariffSynchronizer::BaseUpdate.latest_applied_of_both_kinds

        render json: Api::V2::TariffUpdateSerializer.new(@updates.to_a).serializable_hash
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

      def serialization_meta
        {
          meta: {
            pagination: {
              page: current_page,
              per_page: per_page,
              total_count: @collection.pagination_record_count
            }
          }
        }
      end
    end
  end
end
