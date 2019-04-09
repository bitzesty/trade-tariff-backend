module Api
  module V2
    class SuggestionsService
      def perform
        a = Commodity.select(:goods_nomenclature_sid, :goods_nomenclature_item_id)
              .actual
              .distinct
              .order(Sequel.desc(:goods_nomenclature_item_id))
              .map { |i| Api::V2::SuggestionPresenter.new(i.goods_nomenclature_sid, i.goods_nomenclature_item_id) }
      
        b = SearchReference.select(:id, :title)
              .distinct
              .order(Sequel.desc(:title))
              .map { |i| Api::V2::SuggestionPresenter.new(i.id, i.title) }
        [a, b].flatten.compact
      end
    end
  end
end
