class QuotaSuspensionPeriod < Sequel::Model
  plugin :oplog, primary_key: :quota_suspension_period_sid
  plugin :conformance_validator

  set_primary_key [:quota_suspension_period_sid]

  dataset_module do
    def last
      order(Sequel.desc(:suspension_end_date)).first
    end
  end

  def self.changes_for(conditions = {})
    operation_klass.select(
      Sequel.as('QuotaSuspensionPeriod', :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(3, :depth)
    ).where(conditions)
     .limit(3)
     .order(Sequel.function(:isnull, :operation_date), Sequel.desc(:operation_date))
  end
end


