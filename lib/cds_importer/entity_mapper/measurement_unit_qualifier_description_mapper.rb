class CdsImporter
  class EntityMapper
    class MeasurementUnitQualifierDescriptionMapper < BaseMapper
      self.entity_class = "MeasurementUnitQualifierDescription".freeze
      self.exclude_mapping = ["validityStartDate", "validityEndDate", "metainfo.origin"].freeze
      self.mapping_path = "measurementUnitQualifierDescription".freeze
      self.entity_mapping = base_mapping.merge(
        "measurementUnitQualifierCode" => :measurement_unit_qualifier_code,
        "#{mapping_path}.description" => :description,
        "#{mapping_path}.language.languageId" => :language_id
      ).freeze
    end
  end
end
