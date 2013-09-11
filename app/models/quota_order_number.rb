class QuotaOrderNumber < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: :quota_definition_sid
  plugin :conformance_validator

  set_primary_key [:quota_order_number_sid]

  one_to_one :quota_definition, key: :quota_order_number_id,
                                primary_key: :quota_order_number_id do |ds|
    ds.with_actual(QuotaDefinition)
  end

  one_to_one :quota_order_number_origin, primary_key: :quota_order_number_sid,
                                         key: :quota_order_number_sid

  delegate :present?, to: :quota_order_number_origin, prefix: true, allow_nil: true

  def changes(conditions = {})
    operation_klass.select(
      Sequel.as('QuotaOrderNumber', :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(1, :depth)
    ).where(pk_hash)
     .where(conditions)
     .limit(3)
     .order(Sequel.function(:isnull, :operation_date), Sequel.desc(:operation_date))
     .union(quota_definition.changes)
  end
end


