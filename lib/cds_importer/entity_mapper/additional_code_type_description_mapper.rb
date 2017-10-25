class CdsImporter
  class EntityMapper
    class AdditionalCodeTypeDescriptionMapper < BaseMapper
      self.entity_class = "AdditionalCodeTypeDescription".freeze

      self.mapping_path = "additionalCodeTypeDescription".freeze

      self.exclude_mapping = ["validityStartDate", "validityEndDate"]

      self.entity_mapping = base_mapping.merge(
        "additionalCodeTypeId" => :additional_code_type_id,
        "additionalCodeTypeDescription.language.languageId" => :language_id,
        "additionalCodeTypeDescription.description" => :description
      )
    end
  end
end
