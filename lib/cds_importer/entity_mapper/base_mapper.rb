class CdsImporter
  class EntityMapper
    class BaseMapper
      NATIONAL = "N".freeze

      def initialize(values)
        @values = values
      end

      def parse
        if Object.const_defined?(KLASS)
          normalized_values = normalize(mapped_values)
          KLASS.constantize.new(normalized_values)
        else
          raise ArgumentError.new("KLASS is undefined for mapper: #{self.class}")
        end
      end

      private

      def mapped_values
        @values.keys.inject({}) do |memo, key|
          mapped_key = MAPPING[key.to_s] || key
          memo[mapped_key] = @values[key]
          memo
        end
      end

      def normalize(values)
        values[:national] = values[:national] == NATIONAL
        values
      end
    end
  end
end
