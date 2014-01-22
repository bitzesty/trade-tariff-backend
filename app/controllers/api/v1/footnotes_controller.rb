module Api
  module V1
    class FootnotesController < ApiController
      before_filter :authenticate_user!

      def index
        @footnotes = Footnote.eager(:footnote_descriptions).national.all

        respond_with @footnotes
      end

      def show
        @footnote = Footnote.national.with_pk!(footnote_pk)
      end

      def update
        @footnote = Footnote.national.with_pk!(footnote_pk)
        @footnote.footnote_description.tap do |footnote_description|
          footnote_description.set(footnote_params)
          footnote_description.save
        end

        respond_with @footnote
      end

      private

      def footnote_params
        params.require(:footnote).permit(:description)
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
