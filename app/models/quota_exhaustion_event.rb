class QuotaExhaustionEvent < Sequel::Model
  plugin :oplog, primary_key: :quota_definition_sid
  plugin :conformance_validator

  set_primary_key [:quota_definition_sid]

  many_to_one :quota_definition, key: :quota_definition_sid,
                                 primary_key: :quota_definition_sid

  def self.status
    'exhausted'
  end

  def changes(conditions = {})
    operation_klass.select(
      Sequel.as('QuotaExhaustionEvent', :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(3, :depth)
    ).where(pk_hash)
     .where(conditions)
     .limit(3)
     .order(Sequel.function(:isnull, :operation_date), Sequel.desc(:operation_date))
  end

  def self.changes_for(conditions = {})
    operation_klass.select(
      Sequel.as('QuotaExhaustionEvent', :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(3, :depth)
    ).where(conditions)
     .limit(3)
     .order(Sequel.function(:isnull, :operation_date), Sequel.desc(:operation_date))
  end
end


