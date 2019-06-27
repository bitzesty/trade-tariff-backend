module Api
  module Admin
    class SearchReferencesController < ApiController
      def index
        @search_references = SearchReference.for_letter(letter).by_title.all

        render json: Api::Admin::SearchReferences::SearchReferenceListSerializer.new(@search_references).serializable_hash
      end

      private

      def letter
        params.fetch(:query, {}).fetch(:letter, 'a')
      end
    end
  end
end
