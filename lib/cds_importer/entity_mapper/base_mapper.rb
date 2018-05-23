class CdsImporter
  class EntityMapper
    class BaseMapper
      class << self
        # entity_class    - model
        # entity_mapping  - attributes mapping
        # mapping_path    - path to attributes in xml
        # mapping_root    - node name in xml that provides data for mapping
        # exclude_mapping - list of excluded attributes
        attr_accessor :entity_class, :entity_mapping, :mapping_path, :mapping_root, :exclude_mapping

        def base_mapping
          BASE_MAPPING.except(*exclude_mapping).keys.inject({}) do |memo, key|
            mapped_key = mapping_path.present? ? "#{mapping_path}.#{key}" : key
            memo[mapped_key] = BASE_MAPPING[key]
            memo
          end
        end
      end

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
        normalized_values = normalize(mapped_values)
        instance = entity_class.constantize.new
        instance.set_fields(normalized_values, entity_mapping.values)
      end

      protected

      def entity_class
        self.class.entity_class.presence || raise(ArgumentError.new("entity_class has not been defined: #{self.class}"))
      end

      def entity_mapping
        self.class.entity_mapping.presence || raise(ArgumentError.new("entity_mapping has not been defined: #{self.class}"))
      end

      def mapped_values
        entity_mapping.keys.inject({}) do |memo, key|
          mapped_key = entity_mapping.fetch(key)
          memo[mapped_key] = @values.dig(*key.split("."))
          memo
        end
      end

      def normalize(values)
        values[:national] = values[:national] == NATIONAL if values.key?(:national)
        values[:approved_flag] = values[:approved_flag] == '1' if values.key?(:approved_flag)
        values[:stopped_flag] = values[:stopped_flag] == '1' if values.key?(:approved_flag)
        values
      end
    end
  end
end
