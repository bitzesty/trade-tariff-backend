#
# FootnoteAssociationMeasure is nested in to Measure.
#

class CdsImporter
  class EntityMapper
    class FootnoteAssociationMeasureMapper < BaseMapper
      self.exclude_mapping = ["validityStartDate", "validityEndDate"].freeze

      self.entity_class = "FootnoteAssociationMeasure".freeze

      self.mapping_path = "footnoteAssociationMeasure".freeze

      self.entity_mapping = base_mapping.merge(
        "sid" => :measure_sid,
        "#{mapping_path}.footnote.footnoteType.footnoteTypeId" => :footnote_type_id,
        "#{mapping_path}.footnote.footnoteId" => :footnote_id
      ).freeze
    end
  end
end
