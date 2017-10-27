class CdsImporter
  class EntityMapper
    class GeographicalAreaDescriptionMapper < BaseMapper
      self.entity_class = "GeographicalAreaDescription".freeze

      self.mapping_path = "geographicalAreaDescriptionPeriod.geographicalAreaDescription".freeze

      self.exclude_mapping = ["validityStartDate", "validityEndDate"].freeze

      self.entity_mapping = base_mapping.merge(
        "geographicalAreaDescriptionPeriod.sid" => :geographical_area_description_period_sid,
        "geographicalAreaDescriptionPeriod.geographicalAreaDescription.language.languageId" => :language_id,
        "sid" => :geographical_area_sid,
        "geographicalAreaId" => :geographical_area_id,
        "geographicalAreaDescriptionPeriod.geographicalAreaDescription.description" => :description
      ).freeze
    end
  end
end
