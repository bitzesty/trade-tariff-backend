class QuotaOrderNumber < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: :quota_order_number_sid
  plugin :conformance_validator

  set_primary_key [:quota_order_number_sid]

  one_to_one :quota_definition, key: :quota_order_number_id,
                                primary_key: :quota_order_number_id do |ds|
    ds.with_actual(QuotaDefinition)
  end

  def quota_definition!
    return nil if quota_order_number_id.starts_with?('094')

    quota_definition(reload: true)
  end
  alias :definition :quota_definition!

  def definition_id
    definition&.quota_order_number_id
  end

  one_to_one :quota_order_number_origin, primary_key: :quota_order_number_sid,
                                         key: :quota_order_number_sid

  delegate :present?, to: :quota_order_number_origin, prefix: true, allow_nil: true
end
