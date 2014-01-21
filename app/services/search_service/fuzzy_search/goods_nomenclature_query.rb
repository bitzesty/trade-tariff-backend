class SearchService
  class FuzzySearch < BaseSearch
    class GoodsNomenclatureQuery < FuzzyQuery
      def query(query_opts = {})
        {
          index: index.name,
          type: index.type,
          search: {
            query: {
              constant_score: {
                filter: {
                  and: [
                    {
                      # match the search phrase
                      query: {
                        multi_match: {
                          query: query_string,
                          fields: ['description']
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
                        },
                        {
                          and: [
                            {
                              missing: {
                                field: "validity_start_date",
                                null_value: true,
                                existence: true
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
       }
      end
    end
  end
end
