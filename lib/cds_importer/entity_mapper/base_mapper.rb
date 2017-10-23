class CdsImporter
  class EntityMapper
    class BaseMapper
      NATIONAL = "N".freeze
      BASE_MAPPING = {
        "validityStartDate" => :validity_start_date,
        "validityEndDate" => :validity_end_date,
        "metainfo.origin" => :national,
        "metainfo.opType" => :operation,
        "metainfo.transactionDate" => :operation_date
      }.freeze

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
        if Object.const_defined?(MAPPING)
          @values.keys.inject({}) do |memo, key|
            mapped_key = MAPPING[key.to_s] || key
            memo[mapped_key] = @values[key]
            memo
          end
        else
          raise ArgumentError.new("MAPPING is undefined for mapper: #{self.class}")
        end
      end

      def normalize(values)
        values[:national] = values[:national] == NATIONAL if values.key?(:national)
        values
      end
    end
  end
end
