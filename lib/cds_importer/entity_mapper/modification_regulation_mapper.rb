class CdsImporter
  class EntityMapper
    class ModificationRegulationMapper < BaseMapper
      self.entity_class = "ModificationRegulation".freeze

      self.exclude_mapping = ["metainfo.origin"].freeze

      self.entity_mapping = base_mapping.merge(
        "modificationRegulationId" => :modification_regulation_id,
        "publishedDate" => :published_date,
        "officialjournalNumber" => :officialjournal_number,
        "officialjournalPage" => :officialjournal_page,
        "baseRegulation.baseRegulationId" => :base_regulation_id,
        "replacementIndicator" => :replacement_indicator,
        "informationText" => :information_text,
        "effectiveEndDate" => :effective_end_date,
        "approvedFlag" => :approved_flag,
        "stoppedFlag" => :stopped_flag,
        # "" => :modification_regulation_role,
        # "" => :base_regulation_role,
        # "" => :explicit_abrogation_regulation_role,
        # "" => :explicit_abrogation_regulation_id,
        # "" => :complete_abrogation_regulation_role,
        # "" => :complete_abrogation_regulation_id
      )
    end
  end
end
