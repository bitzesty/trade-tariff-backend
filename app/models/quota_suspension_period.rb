class QuotaSuspensionPeriod < Sequel::Model
  plugin :oplog, primary_key: :quota_suspension_period_sid
  plugin :conformance_validator

  set_primary_key [:quota_suspension_period_sid]

  dataset_module do
    def last
      order(Sequel.desc(:suspension_end_date)).first
    end
  end
end
