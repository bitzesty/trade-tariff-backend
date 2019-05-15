module CommodityService
  class OverviewMeasuresService

    def initialize(goods_nomenclature_sid, as_of)
      @goods_nomenclature_sid = goods_nomenclature_sid
      @as_of = as_of
    end

    def indexed_measures
      measures = commodity&.overview_measures&.select do |measure|
        if @as_of.present?
          measure.effective_start_date.to_date <= @as_of &&
            (measure.effective_end_date.nil? || measure.effective_end_date.to_date >= @as_of)
        else
          true
        end
      end&.map do |effective_measure|
        effective_measure
      end
      measures || []
    end

    def commodity
      search_client = ::TradeTariffBackend.search_client
      result = search_client.search index: ::Search::CommodityIndex.new(TradeTariffBackend.search_namespace).name, body: { query: { match: { id: @goods_nomenclature_sid } } }
      result&.hits&.hits&.first&._source
    end
  end
end
