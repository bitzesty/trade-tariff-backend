class SearchService
  class BaseSearch
    BLANK_RESULT = {
      goods_nomenclature_match: {
        sections: [], chapters: [], headings: [], commodities: []
      },
      reference_match: {
        sections: [], chapters: [], headings: [], commodities: []
      }
    }

    attr_reader :query_string, :results, :date

    def initialize(query_string, date)
      @query_string = query_string.to_s.squish.downcase
      @date = date
    end

    def present?
      @results.present?
    end
  end
end
