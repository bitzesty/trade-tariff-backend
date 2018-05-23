class CdsImporter
  class EntityMapper
    class GeographicalAreaMembershipMapper < BaseMapper
      self.entity_class = "GeographicalAreaMembership".freeze

      self.mapping_root = "GeographicalArea".freeze

      self.mapping_path = "geographicalAreaMembership".freeze

      self.entity_mapping = base_mapping.merge(
        "sid" => :geographical_area_sid,
        "#{mapping_path}.geographicalAreaGroupSid" => :geographical_area_group_sid
      ).freeze
    end
  end
end
