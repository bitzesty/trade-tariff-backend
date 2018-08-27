class CdsImporter
  class EntityMapper
    class MeasurementUnitMapper < BaseMapper
      self.entity_class = "MeasurementUnit".freeze

      self.mapping_root = "MeasurementUnit".freeze

      self.exclude_mapping = ["metainfo.origin"].freeze

      self.entity_mapping = base_mapping.merge(
        "measurementUnitCode" => :measurement_unit_code
      ).freeze

      self.entity_mapping_key_as_array = mapping_with_key_as_array.freeze
    end
  end
end
