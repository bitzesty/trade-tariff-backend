module Api
  module V1
    module Sections
      class SearchReferencesController < Api::V1::SearchReferencesBaseController
        private

        def search_reference_collection
          section.search_references_dataset
        end

        def search_reference_resource_association_hash
          { section: section }
        end

        def collection_url
          [:api, section, @search_reference]
        end

        def section
          @section ||= Section.with_pk!(params[:section_id])
        end
      end
    end
  end
end
