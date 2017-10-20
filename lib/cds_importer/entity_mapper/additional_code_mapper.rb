class CdsImporter
  class EntityMapper
    class AdditionalCodeMapper
      KLASS = "AdditionalCode".freeze
      MAPPING = {
        "sid" => :additional_code_sid,
        "additionalCodeCode" => :additional_code
      }.freeze

      def initialize(values)
        @values = values
      end

      def parse
        KLASS.constantize.new(mapped_values)
      end

      private

      def mapped_values
        @values.keys.inject({}) do |memo, key|
          mapped_key = MAPPING[key.to_s] || key
          memo[mapped_key] = @values[key]
          memo
        end
      end
    end
  end
end
