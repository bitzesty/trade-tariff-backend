class CdsImporter
  class EntityMapper
    class FootnoteMapper < BaseMapper
      self.entity_class = "Footnote".freeze
      self.entity_mapping = BASE_MAPPING.merge(
        "footnoteId" => :footnote_id,
        "footnoteType.footnoteTypeId" => :footnote_type_id
      ).freeze
    end
  end
end
