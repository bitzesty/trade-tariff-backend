class SearchService
  class ExactSearch < BaseSearch
    def search!
      @results = case query_string
                 when /^[0-9]{1,3}$/
                   Chapter.actual
                          .by_code(query_string.to_s.rjust(2, '0'))
                          .non_hidden
                          .first
                 when /^[0-9]{4,9}$/
                   Heading.actual
                          .by_code(query_string)
                          .non_hidden
                          .first
                 when /^[0-9]{10}$/
                   Commodity.actual
                            .by_code(query_string)
                            .non_hidden
                            .declarable
                            .first
                            .presence ||
                   Heading.actual
                          .by_declarable_code(query_string)
                          .declarable
                          .non_hidden
                          .first
                          .presence
                 when /^[0-9]{11,12}$/
                   Commodity.actual
                            .by_code(query_string)
                            .non_hidden
                            .declarable
                            .first
                 end

      self
    end

    def present?
      !query_string.in?(HiddenGoodsNomenclature.codes) && @results.present?
    end

    def serializable_hash
      {
        type: "exact_match",
        entry: {
          endpoint: results.class.name.parameterize("_").pluralize,
          id: results.to_param
        }
      }
    end
  end
end
