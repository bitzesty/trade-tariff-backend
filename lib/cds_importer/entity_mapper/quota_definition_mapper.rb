class CdsImporter
  class EntityMapper
    class QuotaDefinitionMapper < BaseMapper
      self.exclude_mapping = ["metainfo.origin"].freeze
      self.entity_class = "QuotaDefinition".freeze
      self.entity_mapping = base_mapping.merge(
        "sid" => :quota_definition_sid,
        "quotaOrderNumber.sid" => :quota_order_number_sid,
        "quotaOrderNumber.quotaOrderNumberId" => :quota_order_number_id,
        "volume" => :volume,
        "initialVolume" => :initial_volume,
        "measurementUnit.measurementUnitCode" => :measurement_unit_code,
        "maximumPrecision" => :maximum_precision,
        "criticalState" => :critical_state,
        "criticalThreshold" => :critical_threshold
      ).freeze
    end
  end
end
