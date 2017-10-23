class CdsImporter
  class EntityMapper
    class BaseRegulationMapper < BaseMapper
      KLASS = "BaseRegulation".freeze
      MAPPING = {
        "regulationRoleType.regulationRoleTypeId" => :base_regulation_role,
        "baseRegulationId" => :base_regulation_id,
        "validityStartDate" => :validity_start_date,
        "validityEndDate" => :validity_end_date,
        "communityCode" => :community_code,
        "regulationGroup.regulationGroupId" => :regulation_group_id,
        "replacementIndicator" => :replacement_indicator,
        "stoppedFlag" => :stopped_flag,
        "approvedFlag" => :approved_flag,
        "informationText" => :information_text,
        "publishedDate" => :published_date,
        "officialjournalNumber" => :officialjournal_number,
        "officialjournalPage" => :officialjournal_page,
        "effectiveEndDate" => :effective_end_date,
        "antidumpingRegulationRole" => :antidumping_regulation_role,
        "relatedAntidumpingRegulationId" => :related_antidumping_regulation_id,
        "completeAbrogationRegulation.regulationRoleType.regulationRoleTypeId" => :complete_abrogation_regulation_role,
        "completeAbrogationRegulation.completeAbrogationRegulationId" => :complete_abrogation_regulation_id,
        "explicitAbrogationRegulation.regulationRoleType.regulationRoleTypeId" => :explicit_abrogation_regulation_role,
        "explicitAbrogationRegulation.explicitAbrogationRegulationId" => :explicit_abrogation_regulation_id,
        "metainfo.origin" => :national,
        "metainfo.opType" => :operation,
        "metainfo.transactionDate" => :operation_date
      }.freeze
    end
  end
end
