module Api
  module V1
    module Chapters
      class SearchReferencesController < Api::V1::SearchReferencesController
        private

        def search_reference_collection
          chapter.search_references_dataset.eager(:chapter)
        end

        def search_reference_resource_association_hash
          { chapter_id: chapter.short_code }
        end

        def collection_url
          [:api, chapter, @search_reference]
        end

        def chapter
          @chapter ||= Chapter.find(goods_nomenclature_item_id: chapter_id)
        end

        def chapter_id
          # Converts 8 to 0800000000, 18 to 1800000000
          # May result in 0000000000 but there is no such chapter
          params[:chapter_id].to_s.rjust(2, '0').ljust(10, '0')
        end
      end
    end
  end
end
