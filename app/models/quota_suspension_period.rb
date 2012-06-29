class QuotaSuspensionPeriod < ActiveRecord::Base
  self.primary_key = :quota_suspension_period_sid

  belongs_to :quota_definition, primary_key: :quota_definition_sid
end
