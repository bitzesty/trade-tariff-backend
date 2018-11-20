module CommodityService
  class OverviewMeasuresService

    def initialize(goods_nomenclature_sid, as_of)
      @goods_nomenclature_sid = goods_nomenclature_sid
      @as_of = as_of
    end

    def measure_sids
      commodity&.overview_measures&.select do |measure|
        if @as_of.present?
          measure.effective_start_date.to_date <= @as_of &&
              (measure.effective_end_date == nil || measure.effective_end_date.to_date >= @as_of)
        else
          true
        end
      end&.map do |measure|
        measure.measure_sid
      end
    end

    def commodity
      search_client = ::TradeTariffBackend.search_client
      result = search_client.search index: 'tariff-commodities', body: {query: {match: {id: @goods_nomenclature_sid}}}
      result&.hits&.hits&.first&._source
    end

  end
end
