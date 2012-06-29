class QuotaBlockingPeriod < ActiveRecord::Base
  self.primary_key = :quota_blocking_period_sid

  belongs_to :quota_definition, foreign_key: :quota_definition_sid
end
