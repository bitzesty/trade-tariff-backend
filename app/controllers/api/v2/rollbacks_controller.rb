module Api
  module V2
    class RollbacksController < ApiController
      before_action :authenticate_user!
      before_action :collection, only: :index

      def index
        render json: Api::V2::RollbackSerializer.new(@collection.to_a, pagination_links).serializable_hash
      end

      def create
        rollback = Rollback.new(rollback_params)

        if rollback.valid?
          rollback.save
          render json: Api::V2::RollbackSerializer.new(rollback).serializable_hash, status: :created, location: api_rollbacks_url
        else
          render json: Api::V2::RollbackSerializer.new(rollback).serialized_errors, status: :unprocessable_entity
        end
      end

      private

      def rollback_params
        params.require(:rollback).permit(:date, :keep, :reason, :user_id)
      end

      def collection
        @collection ||= Rollback.descending.paginate(current_page, per_page)
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
