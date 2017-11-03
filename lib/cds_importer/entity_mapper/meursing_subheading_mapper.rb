#
# MeursingSubheading is nested in to MeursingHeading.
# BUT also MeursingHeading is nested in to MeursingSubheading.
# SO it's not clear which api call will retrun MeursingSubheading records
#

class CdsImporter
  class EntityMapper
    class MeursingSubheadingMapper < BaseMapper
      self.entity_class = "MeursingSubheading".freeze

      self.exclude_mapping = ["metainfo.origin"].freeze

      self.entity_mapping = base_mapping.merge(
        "meursingHeading.meursingTablePlan.meursingTablePlanId" => :meursing_table_plan_id,
        "meursingHeading.meursingHeadingNumber" => :meursing_heading_number,
        "meursingHeading.rowColumnCode" => :row_column_code,
        "subheadingSequenceNumber" => :subheading_sequence_number,
        "description" => :description
      ).freeze
    end
  end
end
