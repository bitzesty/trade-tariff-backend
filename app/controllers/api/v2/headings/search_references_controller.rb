module Api
  module V2
    module Headings
      class SearchReferencesController < Api::V2::SearchReferencesBaseController
        private

        def search_reference_collection
          heading.search_references_dataset
        end

        def search_reference_resource_association_hash
          { heading: heading }
        end

        def collection_url
          [:api, heading, @search_reference]
        end

        def heading
          @heading ||= begin
            heading = Heading.actual
                   .non_grouping
                   .where(goods_nomenclatures__goods_nomenclature_item_id: heading_id)
                   .take

            raise Sequel::RecordNotFound if heading.goods_nomenclature_item_id.in?(HiddenGoodsNomenclature.codes)

            heading
          end
        end

        def heading_id
          "#{params[:heading_id]}000000"
        end
      end
    end
  end
end
