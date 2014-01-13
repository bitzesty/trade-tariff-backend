module Api
  module V1
    class RollbacksController < ApiController
      before_filter :authenticate_user!

      def index
        @rollback_jobs = Sidekiq::Queue.new("rollbacks")
      end

      def create
        rollback = Rollback.new(rollback_params)

        if rollback.valid?
          RollbackWorker.perform_async(rollback.date, rollback.redownload)

          head :created, location: api_rollbacks_url
        else
          render json: rollback, status: :unprocessable_entity
        end
      end

      private

      def rollback_params
        params.require(:rollback).permit(:date, :redownload)
      end
    end
  end
end
