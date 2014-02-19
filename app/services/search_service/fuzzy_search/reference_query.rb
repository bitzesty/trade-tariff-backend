class SearchService
  class FuzzySearch < BaseSearch
    class ReferenceQuery < FuzzyQuery
      def query(*)
        {
          index: "#{TradeTariffBackend.search_namespace}-search_references",
          type: 'search_reference',
          search: {
            query: {
              filtered: {
                query: {
                  multi_match: {
                    query: query_string,
                    fields: ['title'],
                    operator: 'and' # all terms must be present
                  }
                },
                filter: {
                  and: [
                    {
                      term: { reference_class: index.type }
                    },
                    {
                      nested: {
                        path: "reference",
                        query: {
                          filtered: {
                            query: { match_all: {} },
                            filter: {
                              or: [
                                # actual date is either between item's (validity_start_date..validity_end_date)
                                {
                                  and: [
                                    range: {
                                      "reference.validity_start_date" => { lte: date }
                                    },
                                    range: {
                                      "reference.validity_end_date" => { gte: date }
                                    }
                                  ]
                                },
                                # or is greater than item's validity_start_date
                                # and item has blank validity_end_date (is unbounded)
                                {
                                  and: [
                                    {
                                      range: {
                                        "reference.validity_start_date" => { lte: date }
                                      }
                                    },
                                    {
                                      missing: {
                                        field: "reference.validity_end_date",
                                        null_value: true,
                                        existence: true
                                      }
                                    }
                                  ]
                                },
                                # Sections do not have validity start/end dates
                                {
                                  and: [
                                    {
                                      missing: {
                                        field: "reference.validity_start_date",
                                        null_value: true,
                                        existence: true
                                      }
                                    },
                                    {
                                      missing: {
                                        field: "reference.validity_end_date",
                                        null_value: true,
                                        existence: true
                                      }
                                    }
                                  ]
                                }
                              ]
                            }
                          }
                        }
                      }
                    }
                  ]
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
