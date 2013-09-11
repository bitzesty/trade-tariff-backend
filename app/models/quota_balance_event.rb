class QuotaBalanceEvent < Sequel::Model
  plugin :oplog, primary_key: [:quota_definition_sid,
                               :occurrence_timestamp]
  plugin :conformance_validator

  set_primary_key  [:quota_definition_sid, :occurrence_timestamp]

  many_to_one :quota_definition, key: :quota_definition_sid,
                                 primary_key: :quota_definition_sid

  dataset_module do
    def last
      order(Sequel.desc(:occurrence_timestamp)).first
    end
  end

  def self.status
    'open'
  end

  def self.changes_for(conditions = {})
    operation_klass.select(
      Sequel.as('QuotaBalanceEvent', :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(3, :depth)
    ).where(conditions)
     .limit(3)
     .order(Sequel.function(:isnull, :operation_date), Sequel.desc(:operation_date))
  end
end


