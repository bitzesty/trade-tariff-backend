module Api
  module V1
    class RollbacksController < ApiController
      before_filter :authenticate_user!
      after_filter :paginate, only: :index

      PER_PAGE = 20

      def index
        @rollback_jobs = collection
      end

      def create
        rollback = Rollback.new(rollback_params)
        
        if rollback.valid?
          rollback.save
          render json: rollback, status: :created, location: api_rollbacks_url
        else
          render json: { errors: rollback.errors }, status: :unprocessable_entity
        end
      end

      private

      def rollback_params
        params.require(:rollback).permit(:date, :keep, :reason, :user_id)
      end

      def collection
        @collection ||= Rollback.descending.paginate(page, PER_PAGE)
      end

      def paginate
        response.headers["X-Pagination"] = {
          page: page,
          per_page: PER_PAGE,
          total_count: collection.pagination_record_count
        }.to_json
      end

      def page
        Integer(params[:page] || 1)
      end
    end
  end
end
