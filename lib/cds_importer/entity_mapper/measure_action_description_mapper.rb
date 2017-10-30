class CdsImporter
  class EntityMapper
    class MeasureActionDescriptionMapper < BaseMapper
      self.exclude_mapping = ["validityStartDate", "validityEndDate", "metainfo.origin"].freeze
      self.mapping_path = "measureActionDescription".freeze
      self.entity_class = "MeasureActionDescription".freeze
      self.entity_mapping = base_mapping.merge(
        "actionCode" => :action_code,
        "#{mapping_path}.language.languageId" => :language_id,
        "#{mapping_path}.description" => :description
      ).freeze
    end
  end
end
