class SearchService
  class FuzzySearch < BaseSearch
    class CasNumberQuery < FuzzyQuery
      def query(*)
        {
          index: "#{TradeTariffBackend.search_namespace}-cas_numbers",
          type: 'cas_number',
          search: {
            query: {
              bool: {
                must: {
                  multi_match: {
                    query: query_string,
                    fields: ['title'],
                    operator: 'and' # all terms must be present
                  }
                },
                filter: {
                  bool: {
                    must: [
                      {
                        nested: {
                          path: "references",
                          query: {
                            bool: {
                              must: { match_all: {} },
                              filter: {
                                bool: {
                                  should: [
                                    # actual date is either between item's (validity_start_date..validity_end_date)
                                    {
                                      bool: {
                                        must: [
                                          { range: { "references.validity_start_date" => { lte: date } } },
                                          { range: { "references.validity_end_date" => { gte: date } } }
                                        ]
                                      }
                                    },
                                    # or is greater than item's validity_start_date
                                    # and item has blank validity_end_date (is unbounded)
                                    {
                                      bool: {
                                        must: [
                                          { range: { "references.validity_start_date" => { lte: date } } },
                                          { bool: { must_not: { exists: { field: "references.validity_end_date" } } } }
                                        ]
                                      }
                                    },
                                    # or item has blank validity_start_date and validity_end_date
                                    {
                                      bool: {
                                        must: [
                                          { bool: { must_not: { exists: { field: "references.validity_start_date" } } } },
                                          { bool: { must_not: { exists: { field: "references.validity_end_date" } } } }
                                        ]
                                      }
                                    }
                                  ]
                                }
                              }
                            }
                          }
                        }
                      }
                    ]
                  }
                }
              },
            },
            size: INDEX_SIZE_MAX
          }
        }
      end
    end
  end
end
