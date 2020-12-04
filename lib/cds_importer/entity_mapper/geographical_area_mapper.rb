class CdsImporter
  class EntityMapper
    class GeographicalAreaMapper < BaseMapper
      self.entity_class = "GeographicalArea".freeze

      self.mapping_root = "GeographicalArea".freeze

      self.entity_mapping = base_mapping.merge(
        "sid" => :geographical_area_sid,
        "geographicalCode" => :geographical_code,
        "geographicalAreaId" => :geographical_area_id,
        "parentGeographicalAreaGroupSid" => :parent_geographical_area_group_sid
      ).freeze

      self.entity_mapping_key_as_array = mapping_with_key_as_array.freeze

      self.entity_mapping_keys_to_parse = mapping_keys_to_parse.freeze
    end
  end
end
