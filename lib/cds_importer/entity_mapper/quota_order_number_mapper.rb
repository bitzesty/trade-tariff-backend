class CdsImporter
  class EntityMapper
    class QuotaOrderNumberMapper < BaseMapper
      self.exclude_mapping = ["metainfo.origin"].freeze
      self.entity_class = "QuotaOrderNumber".freeze
      self.entity_mapping = base_mapping.merge(
        "sid" => :quota_order_number_sid,
        "quotaOrderNumberId" => :quota_order_number_id
      ).freeze
    end
  end
end
