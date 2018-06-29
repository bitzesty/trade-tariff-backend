#
# Measurement in nested in to MeasurementUnit.
#

class CdsImporter
  class EntityMapper
    class MeasurementMapper < BaseMapper
      self.entity_class = "Measurement".freeze

      self.mapping_root = "MeasurementUnit".freeze

      self.mapping_path = "measurementUnitQualifier".freeze

      self.exclude_mapping = ["metainfo.origin"].freeze

      self.entity_mapping = base_mapping.merge(
        "measurementUnitCode" => :measurement_unit_code,
        "measurementUnitQualifier.measurementUnitQualifierCode" => :measurement_unit_qualifier_code
      ).freeze
    end
  end
end
