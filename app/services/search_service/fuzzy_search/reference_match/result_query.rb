class SearchService
  class FuzzySearch < BaseSearch
    class ReferenceMatch
      class ResultQuery
        attr_reader :result

        def initialize(results = [])
          @results = results.clone
        end

        def for(entity_name)
          @results = @results.select { |result|
            result.reference['class'] == entity_name
          }

          self
        end

        def uniq_by(uniq_key)
          @results = @results.uniq { |result|
            result.reference[uniq_key]
          }

          self
        end

        def sort_by(sort_key)
          @results = @results.sort_by { |result|
            result.reference[sort_key]
          }

          self
        end

        def all
          @results
        end
      end
    end
  end
end
