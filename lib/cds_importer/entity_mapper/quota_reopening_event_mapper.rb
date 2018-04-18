#
# QuotaReopeningEvent is nested in to QuotaDefinition.
#

class CdsImporter
  class EntityMapper
    class QuotaReopeningEventMapper < BaseMapper
      self.mapping_path = "quotaReopeningEvent".freeze

      self.exclude_mapping = ["metainfo.origin", "validityStartDate", "validityEndDate"].freeze

      self.entity_class = "QuotaReopeningEvent".freeze

      self.entity_mapping = base_mapping.merge(
          "sid" => :quota_definition_sid,
          "#{mapping_path}.occurrenceTimestamp" => :occurrence_timestamp,
          "#{mapping_path}.reopeningDate" => :reopening_date
      ).freeze
    end
  end
end