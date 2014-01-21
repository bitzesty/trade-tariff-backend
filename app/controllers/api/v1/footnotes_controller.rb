module Api
  module V1
    class FootnotesController < ApiController
      before_filter :authenticate_user!

      def index
        @footnotes = Footnote.national

        respond_with @footnotes
      end

      def show
        @footnote = Footnote.with_pk(footnote_pk)
      end

      def update
        @footnote = Footnote.with_pk(footnote_pk)

        respond_with @footnote
      end

      private

      def rollback_params
        params.require(:rollback).permit(:date, :redownload)
      end

      def footnote_pk
        [footnote_id[0..1], footnote_id[2, 5]]
      end

      def footnote_id
        params.fetch(:id, '')
      end
    end
  end
end
