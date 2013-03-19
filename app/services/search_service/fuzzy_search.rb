class SearchService
  class FuzzySearch < BaseSearch
    def search!
      begin
        @results = { goods_nomenclature_match: search_results_for(query_string, date),
                     reference_match: reference_results_for(query_string) }
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

    private

    def search_results_for(query_string, date)
      {
        sections: results_for('sections', query_string, date, query_string: { fields: ["title"] }),
        chapters: results_for('chapters', query_string, date),
        headings: results_for('headings', query_string, date),
        commodities: results_for('commodities', query_string, date)
      }
    end

    def reference_results_for(query_string)
      {
        sections: reference_search(query_string).select{ |result|
          result.reference['class'] == 'Section'
        }.uniq { |result|
          result.reference['id']
        },
        chapters: reference_search(query_string).select{ |result|
          result.reference['class'] == 'Chapter'
        }.uniq { |result|
          result.reference['goods_nomenclature_item_id']
        },
        headings: reference_search(query_string).select{ |result|
          result.reference['class'] == 'Heading'
        }.uniq { |result|
          result.reference['goods_nomenclature_item_id']
        },
        commodities: []
      }
    end

    def reference_search(query_string)
      @reference_results ||= Tire.search('search_references', {
                                          query: {
                                            filtered: {
                                              query: {
                                                query_string: {
                                                  fields: ['title'],
                                                  analyzer: 'snowball',
                                                  query: query_string
                                                }
                                              },
                                              filter: {
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
                                                  # Sections do not have validity start/end dates
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
                                             },
                                           },
                                           size: INDEX_SIZE_MAX
                                         }).results
    end

    def results_for(index, query_string, date, query_opts = {})
      Tire.search(index, { query: {
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
                 ).results
    end
  end
end
