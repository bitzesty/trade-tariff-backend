module Api
  module V2
    class SearchReferencesController < ApiController
      def index
        @search_references = SearchReference.for_letter(letter).by_title.all

        render json: Api::V2::SearchReferenceSerializer.new(@search_references).serializable_hash
      end

      private

      def letter
        params.fetch(:query, {}).fetch(:letter, 'a')
      end
    end
  end
end
