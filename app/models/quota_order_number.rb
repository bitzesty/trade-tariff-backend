class QuotaOrderNumber < Sequel::Model
  plugin :time_machine

  set_primary_key  :quota_order_number_sid

  one_to_one :quota_definition, dataset: -> {
    actual(QuotaDefinition).where(quota_order_number_id: quota_order_number_id)
  }
end


