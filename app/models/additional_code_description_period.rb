class AdditionalCodeDescriptionPeriod < ActiveRecord::Base
  self.primary_key = :additional_code_description_period_sid

  has_one :additional_code_description, foreign_key: :additional_code_description_period_sid
end
