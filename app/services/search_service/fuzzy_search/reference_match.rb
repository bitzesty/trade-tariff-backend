class SearchService
  class FuzzySearch < BaseSearch
    class ReferenceMatch < FuzzyMatch
      autoload :ResultQuery, 'search_service/fuzzy_search/reference_match/result_query'

      def sections
        @sections ||= ResultQuery.new(search_results).for('Section')
                                                     .uniq_by('id')
                                                     .sort_by('position')
                                                     .all
      end

      def chapters
        @chapters ||= ResultQuery.new(search_results).for('Chapter')
                                                     .uniq_by('goods_nomenclature_item_id')
                                                     .sort_by('goods_nomenclature_item_id')
                                                     .all
      end

      def headings
        @headings ||= ResultQuery.new(search_results).for('Heading')
                                                     .uniq_by('goods_nomenclature_item_id')
                                                     .sort_by('goods_nomenclature_item_id')
                                                     .all
      end

      def serializable_hash
        {
          sections: sections,
          chapters: chapters,
          headings: headings,
          commodities: []
        }
      end

      private

      def search_results
        @search_results ||= Tire.search('search_references', {
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
             },
           },
           size: INDEX_SIZE_MAX
         }
        ).results
      end
    end
  end
end
