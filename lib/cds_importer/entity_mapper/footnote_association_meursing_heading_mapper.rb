#
# FootnoteAssociationMeursingHeading is nested in to MeursingHeading.
#

class CdsImporter
  class EntityMapper
    class FootnoteAssociationMeursingHeadingMapper < BaseMapper
      self.exclude_mapping = ["metainfo.origin"].freeze

      self.entity_class = "FootnoteAssociationMeursingHeading".freeze

      self.mapping_path = "footnoteAssociationMeursingHeading".freeze

      self.entity_mapping = base_mapping.merge(
        "meursingTablePlan.meursingTablePlanId" => :meursing_table_plan_id,
        "meursingHeadingNumber" => :meursing_heading_number,
        "rowColumnCode" => :row_column_code,
        "#{mapping_path}.footnote.footnoteType.footnoteTypeId" => :footnote_type,
        "#{mapping_path}.footnote.footnoteId" => :footnote_id
      ).freeze
    end
  end
end
