module Api
  module V2
    class FootnotesController < ApiController
      before_action :authenticate_user!

      def index
        @footnotes = Footnote.actual.eager(:footnote_descriptions).national.all

        render json: Api::V2::FootnoteSerializer.new(@footnotes).serializable_hash
      end

      def show
        @footnote = Footnote.national.with_pk!(footnote_pk)

        render json: Api::V2::FootnoteSerializer.new(@footnote).serializable_hash
      end

      def update
        @footnote = Footnote.national.with_pk!(footnote_pk)
        @footnote.footnote_description.tap do |footnote_description|
          footnote_description.set(footnote_params)
          footnote_description.save
        end

        render json: Api::V2::FootnoteSerializer.new(@footnote).serializable_hash
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
