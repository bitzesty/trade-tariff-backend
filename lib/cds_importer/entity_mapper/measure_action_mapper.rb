class CdsImporter
  class EntityMapper
    class MeasureActionMapper < BaseMapper
      self.exclude_mapping = ["metainfo.origin"].freeze
      self.entity_class = "MeasureAction".freeze
      self.entity_mapping = base_mapping.merge(
        "actionCode" => :action_code
      ).freeze
    end
  end
end
