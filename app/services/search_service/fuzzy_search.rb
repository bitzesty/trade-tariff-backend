class SearchService
  class FuzzySearch < BaseSearch
    autoload :FuzzyMatch,             'search_service/fuzzy_search/fuzzy_match'
    autoload :GoodsNomenclatureMatch, 'search_service/fuzzy_search/goods_nomenclature_match'
    autoload :ReferenceMatch,         'search_service/fuzzy_search/reference_match'

    def search!
      begin
        @results = { goods_nomenclature_match: GoodsNomenclatureMatch.for(query_string, date),
                     reference_match:          ReferenceMatch.for(query_string, date) }
      rescue Tire::Search::SearchRequestFailed
        # rescue from malformed queries, return empty resultset in that case
        BLANK_RESULT
      end

      self
    end

    def serializable_hash
      {
        type: "fuzzy_match",
      }.merge(results)
    end
  end
end
