class QuotaSuspensionPeriod < Sequel::Model
  set_primary_key  :quota_suspension_period_sid

  dataset_module do
    def last
      order(:suspension_end_date.desc).first
    end
  end
end


