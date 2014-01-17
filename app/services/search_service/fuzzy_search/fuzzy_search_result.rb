class SearchService
  class FuzzySearch < BaseSearch
    class FuzzySearchResult
      include Enumerable

      # We craft Elasticsearch queries in streamlined way, but
      # certain queries need additional query details to be provided.
      # These details can be specified in QUERY_OPTIONS
      #
      # See #each_query for more details
      QUERY_OPTIONS = {
        goods_nomenclature_match: {
          'tariff-sections' => { fields: ["title"] }
        }
      }

      def initialize(query_string, date)
        @query_string = query_string
        @date = date
      end

      # Elasticsearch multisearch endpoint returns results in the same
      # order as the queries were passed so we rely on #each_query to
      # yield the queries for search and result output
      #
      # More here http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-multi-search.html
      def each
        return to_enum(:each) unless block_given?
        each_query.each_with_index do |(match_type, search_index, _), idx|
          yield match_type, search_index, search_results[idx].hits.hits
        end
      end

      def search_results
        @search_results ||= TradeTariffBackend.search_client.msearch(
          body: each_query.map { |_, _, query| query }
        ).responses
      end

      def each_query(&block)
        return to_enum(:each_query) unless block_given?

        TradeTariffBackend.search_indexes.select(&:goods_nomenclature?).each do |search_index|
          [
            GoodsNomenclatureQuery.new(@query_string, @date, search_index),
            ReferenceQuery.new(@query_string, @date, search_index)
          ].each do |search_query|
            yield search_query.match_type,
                  search_query.index,
                  search_query.query(
                    QUERY_OPTIONS.fetch(search_query.match_type, {}).fetch(search_query.index.name, {})
                  )
          end
        end
      end
    end
  end
end
