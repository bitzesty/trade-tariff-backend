#
# MeursingHeadingText is nested in to MeursingHeading.
# AND also MeursingHeading is nested in to MeursingTablePlan.
# SO it's not clear which api call will return MeursingHeadingText records
#

class CdsImporter
  class EntityMapper
    class MeursingHeadingTextMapper < BaseMapper
      self.entity_class = "MeursingHeadingText".freeze

      self.mapping_path = "meursingHeadingText"

      self.exclude_mapping = ["metainfo.origin", "validityStartDate", "validityEndDate"].freeze

      self.entity_mapping = base_mapping.merge(
        "meursingTablePlan.meursingTablePlanId" => :meursing_table_plan_id,
        "meursingHeadingNumber" => :meursing_heading_number,
        "rowColumnCode" => :row_column_code,
        "#{mapping_path}.language.languageId" => :language_id,
        "#{mapping_path}.description" => :description
      ).freeze
    end
  end
end
