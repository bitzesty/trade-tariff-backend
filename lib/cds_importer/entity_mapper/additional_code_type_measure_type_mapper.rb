class CdsImporter
  class EntityMapper
    class AdditionalCodeTypeMeasureTypeMapper < BaseMapper
      self.entity_class = "AdditionalCodeTypeMeasureType".freeze

      self.mapping_path = "additionalCodeTypeMeasureType".freeze

      self.entity_mapping = base_mapping.merge(
        "additionalCodeTypeMeasureType.measureType.measureTypeId" => :measure_type_id,
        "additionalCodeTypeMeasureType.additionalCodeType.additionalCodeTypeId" => :additional_code_type_id
      )
    end
  end
end
