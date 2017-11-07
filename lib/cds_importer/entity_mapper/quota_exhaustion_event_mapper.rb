#
# QuotaExhaustionEvent is nested in to QuotaDefinition.
#

class CdsImporter
  class EntityMapper
    class QuotaExhaustionEventMapper < BaseMapper
      self.mapping_path = "quotaExhaustionEvent".freeze

      self.exclude_mapping = ["metainfo.origin", "validityStartDate", "validityEndDate"].freeze

      self.entity_class = "QuotaExhaustionEvent".freeze

      self.entity_mapping = base_mapping.merge(
        "sid" => :quota_definition_sid,
        "#{mapping_path}.occurrenceTimestamp" => :occurrence_timestamp,
        "#{mapping_path}.exhaustionDate" => :exhaustion_date
      ).freeze
    end
  end
end
