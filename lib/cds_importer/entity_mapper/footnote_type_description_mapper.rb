class CdsImporter
  class EntityMapper
    class FootnoteTypeDescriptionMapper < BaseMapper
      self.entity_class = "FootnoteTypeDescription".freeze

      self.mapping_path = "footnoteTypeDescription".freeze

      self.exclude_mapping = ["validityStartDate", "validityEndDate"].freeze

      self.entity_mapping = base_mapping.merge(
        "footnoteTypeId" => :footnote_type_id,
        "footnoteTypeDescription.language.languageId" => :language_id,
        "footnoteTypeDescription.description" => :description
      ).freeze
    end
  end
end
