module Api
  module V1
    class SearchReferencesController < ApiController
      def index
        @search_references = SearchReference.for_letter(letter).by_title.all

        render json: Api::V1::SearchReferenceSerializer.new(@search_references).serializable_hash
      end

      private

      def letter
        params.fetch(:letter, 'a')
      end
    end
  end
end
