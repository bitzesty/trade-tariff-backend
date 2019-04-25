class QuotaOrderNumber < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: :quota_order_number_sid
  plugin :conformance_validator

  set_primary_key [:quota_order_number_sid]

  one_to_one :quota_definition, key: :quota_order_number_sid,
                                primary_key: :quota_order_number_sid do |ds|
    ds.with_actual(QuotaDefinition)
  end

  def quota_definition!
    return nil if quota_order_number_id.starts_with?('094')

    quota_definition(reload: true)
  end
  alias :definition :quota_definition!

  def definition_id
    definition&.quota_order_number_sid
  end

  one_to_one :quota_order_number_origin, primary_key: :quota_order_number_sid,
                                         key: :quota_order_number_sid do |ds|
    ds.with_actual(QuotaOrderNumberOrigin)
  end

  delegate :present?, to: :quota_order_number_origin, prefix: true, allow_nil: true
  delegate :geographical_area, to: :quota_order_number_origin, allow_nil: true
  
  def geographical_area_id
    geographical_area&.id
  end
end
