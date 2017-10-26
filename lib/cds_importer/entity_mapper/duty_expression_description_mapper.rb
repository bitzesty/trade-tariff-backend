#
# There is no collection with DutyExpressionDescription in new xml.
# DutyExpressionDescription is nested in to DutyExpression.
# We will pass @values for DutyExpressionDescription the same as for DutyExpression
#

class CdsImporter
  class EntityMapper
    class DutyExpressionDescriptionMapper < BaseMapper
      self.mapping_path = "dutyExpressionDescription".freeze

      self.exclude_mapping = ["validityStartDate", "validityEndDate", "metainfo.origin"].freeze

      self.entity_class = "DutyExpressionDescription".freeze

      self.entity_mapping = base_mapping.merge(
        "dutyExpressionId" => :duty_expression_id,
        "dutyExpressionDescription.language.languageId" => :language_id,
        "dutyExpressionDescription.description" => :description
      ).freeze
    end
  end
end
