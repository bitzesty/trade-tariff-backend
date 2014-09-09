module Api
  module V1
    class RollbacksController < ApiController
      before_filter :authenticate_user!

      def index
        @rollback_jobs = Rollback.descending
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
    end
  end
end
