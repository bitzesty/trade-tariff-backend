class QuotaBlockingPeriod < Sequel::Model
  plugin :oplog, primary_key: :quota_definition_sid
  plugin :conformance_validator

  set_primary_key [:quota_blocking_period_sid]

  dataset_module do
    def last
      order(Sequel.desc(:end_date)).first
    end
  end
end


