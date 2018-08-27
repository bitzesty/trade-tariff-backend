class CdsImporter
  class EntityMapper
    class AdditionalCodeTypeMeasureTypeMapper < BaseMapper
      self.entity_class = "AdditionalCodeTypeMeasureType".freeze

      self.mapping_root = "AdditionalCodeType".freeze

      self.mapping_path = "additionalCodeTypeMeasureType".freeze

      self.entity_mapping = base_mapping.merge(
        "#{mapping_path}.measureType.measureTypeId" => :measure_type_id,
        "additionalCodeTypeId" => :additional_code_type_id
      ).freeze

      self.entity_mapping_key_as_array = mapping_with_key_as_array.freeze
    end
  end
end
