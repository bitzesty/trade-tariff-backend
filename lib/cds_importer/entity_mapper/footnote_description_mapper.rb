class CdsImporter
  class EntityMapper
    class FootnoteDescriptionMapper < BaseMapper
      self.entity_class = "FootnoteDescription".freeze

      self.mapping_path = "footnoteDescriptionPeriod.footnoteDescription".freeze

      self.exclude_mapping = ["validityStartDate", "validityEndDate"].freeze

      self.entity_mapping = base_mapping.merge(
        "footnoteDescriptionPeriod.footnoteDescriptionPeriodSid" => :footnote_description_period_sid,
        "footnoteType.footnoteTypeId" => :footnote_type_id,
        "footnoteId" => :footnote_id,
        "footnoteDescriptionPeriod.footnoteDescription.language.languageId" => :language_id,
        "footnoteDescriptionPeriod.footnoteDescription.description" => :description
      ).freeze
    end
  end
end
