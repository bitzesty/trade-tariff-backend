class CdsImporter
  class EntityMapper
    class GeographicalAreaMapper < BaseMapper
      self.entity_class = "GeographicalArea".freeze

      self.mapping_root = "GeographicalArea".freeze

      self.exclude_mapping = ["validityStartDate", "validityEndDate"].freeze

      self.entity_mapping = base_mapping.merge(
        "sid" => :geographical_area_sid,
        "geographicalCode" => :geographical_code,
        "geographicalAreaId" => :geographical_area_id
      ).freeze

      self.entity_mapping_key_as_array = mapping_with_key_as_array.freeze
    end
  end
end
