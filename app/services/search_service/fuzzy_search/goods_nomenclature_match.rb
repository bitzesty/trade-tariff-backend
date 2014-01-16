class SearchService
  class FuzzySearch < BaseSearch
    class GoodsNomenclatureMatch < FuzzyMatch
      def serializable_hash
        {
          sections:    search_results_for('tariff-sections', query_string: { fields: ["title"] }),
          chapters:    search_results_for('tariff-chapters'),
          headings:    search_results_for('tariff-headings'),
          commodities: search_results_for('tariff-commodities')
        }
      end

      private

      def search_results_for(index, query_opts = {})
        TradeTariffBackend.search_client.search(index: index,
                                body:
                                  { query: {
                                  constant_score: {
                                    filter: {
                                      and: [
                                        {
                                          # match the search phrase
                                          query: {
                                            query_string: {
                                              query: query_string,
                                              fields: ["description"]
                                            }.merge(query_opts)
                                          }
                                        },
                                        {
                                          or: [
                                            # actual date is either between item's (validity_start_date..validity_end_date)
                                            {
                                              and: [
                                                range: {
                                                  validity_start_date: { lte: date }
                                                },
                                                range: {
                                                  validity_end_date: { gte: date }
                                                }
                                              ]
                                            },
                                            # or is greater than item's validity_start_date
                                            # and item has blank validity_end_date (is unbounded)
                                            {
                                              and: [
                                                {
                                                  range: {
                                                    validity_start_date: { lte: date }
                                                  }
                                                },
                                                {
                                                  missing: {
                                                    field: "validity_end_date",
                                                    null_value: true,
                                                    existence: true
                                                  }
                                                }
                                              ]
                                            }
                                          ]
                                        }
                                      ]
                                    }
                                 }
                               },
                             size: INDEX_SIZE_MAX
                           }
                   ).hits.hits
      end
    end
  end
end
