class SearchService
  class FuzzySearch < BaseSearch
    class FuzzyMatch
      attr_reader :query_string,
                  :date

      def self.for(*args)
        new(*args).serializable_hash
      end

      def initialize(query_string, date)
        @query_string = query_string
        @date = date
      end
    end
  end
end
