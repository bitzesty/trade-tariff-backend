class CdsImporter
  class EntityMapper
    class AdditionalCodeDescriptionMapper < BaseMapper
      self.entity_class = "AdditionalCodeDescription".freeze

      self.mapping_path = "additionalCodeDescriptionPeriod.additionalCodeDescription".freeze

      self.exclude_mapping = ["validityStartDate", "validityEndDate"]

      self.entity_mapping = base_mapping.merge(
        "additionalCodeDescriptionPeriod.sid" => :additional_code_description_period_sid,
        "additionalCodeDescriptionPeriod.additionalCodeDescription.language.languageId" => :language_id,
        "sid" => :additional_code_sid,
        "additionalCodeType.additionalCodeTypeId" => :additional_code_type_id,
        "additionalCodeCode" => :additional_code,
        "additionalCodeDescriptionPeriod.additionalCodeDescription.description" => :description
      ).freeze
    end
  end
end
