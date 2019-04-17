module Api
  module V1
    class SuggestionsService < ::BaseSuggestionsService
      protected

      def handle_commodity_record(commodity)
        { value: commodity.goods_nomenclature_item_id }
      end

      def handle_search_reference_record(search_reference)
        { value: search_reference.title }
      end
    end
  end
end
