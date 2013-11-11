module Api
  module V1
    class SearchReferencesController < ApiController
      def index
        @search_references = SearchReference.for_letter(letter).by_title.all

        respond_to do |format|
          format.json {
            render 'api/v1/search_references_base/index'
          }
        end
      end

      private

      def letter
        params.fetch(:letter, 'a')
      end
    end
  end
end
