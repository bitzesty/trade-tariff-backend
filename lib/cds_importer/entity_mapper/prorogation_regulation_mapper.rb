class CdsImporter
  class EntityMapper
    class ProrogationRegulationMapper < BaseMapper
      self.exclude_mapping = ["validityStartDate", "validityEndDate", "metainfo.origin"].freeze
      self.entity_class = "ProrogationRegulation".freeze
      self.entity_mapping = base_mapping.merge(
        "prorogationRegulationId" => :prorogation_regulation_id,
        "publishedDate" => :published_date,
        "officialjournalNumber" => :officialjournal_number,
        "officialjournalPage" => :officialjournal_page,
        "replacementIndicator" => :replacement_indicator,
        "informationText" => :information_text,
        "approvedFlag" => :approved_flag
      ).freeze
    end
  end
end
