module Api
  module V1
    module Commodities
      class SearchReferencesController < Api::V1::SearchReferencesBaseController
        private

        def search_reference_collection
          commodity.search_references_dataset
        end

        def search_reference_resource_association_hash
          { commodity: commodity }
        end

        def collection_url
          [:api, commodity, @search_reference]
        end

        def commodity
          @commodity ||= begin
            commodity = Commodity.actual
                   .declarable
                   .by_code(commodity_id)
                   .take

            raise Sequel::RecordNotFound if commodity.goods_nomenclature_item_id.in?(HiddenGoodsNomenclature.codes)

            commodity
          end
        end

        def commodity_id
          params[:commodity_id]
        end
      end
    end
  end
end
