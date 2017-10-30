class CdsImporter
  class EntityMapper
    class RegulationReplacementMapper < BaseMapper
      self.exclude_mapping = ["validityStartDate", "validityEndDate", "metainfo.origin"].freeze
      self.entity_class = "RegulationReplacement".freeze
      self.entity_mapping = base_mapping.merge(
        "geographicalArea.geographicalAreaId" => :geographical_area_id,
        "replacingRegulationRole" => :replacing_regulation_role,
        "replacingRegulationId" => :replacing_regulation_id,
        "replacedRegulationRole" => :replaced_regulation_role,
        "replacedRegulationId" => :replaced_regulation_id
      ).freeze
    end
  end
end
