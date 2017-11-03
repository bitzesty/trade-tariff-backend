#
# MeursingHeading is nested in to meursingTablePlan.
# BUT also meursingTablePlan is nested in to MeursingHeading.
# SO it's not clear which api call will retrun MeursingHeading records
#

class CdsImporter
  class EntityMapper
    class MeursingHeadingMapper < BaseMapper
      self.entity_class = "MeursingHeading".freeze

      self.exclude_mapping = ["metainfo.origin"].freeze

      self.entity_mapping = base_mapping.merge(
        "meursingTablePlan.meursingTablePlanId" => :meursing_table_plan_id,
        "meursingHeadingNumber" => :meursing_heading_number,
        "rowColumnCode" => :row_column_code
      ).freeze
    end
  end
end
