class QuotaBlockingPeriod < Sequel::Model
  set_primary_key  :quota_blocking_period_sid

  dataset_module do
    def last
      order(:end_date.desc).first
    end
  end
end


