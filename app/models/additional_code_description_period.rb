class AdditionalCodeDescriptionPeriod < ActiveRecord::Base
  self.primary_key = :additional_code_description_period_sid

  has_one :description, foreign_key: :additional_code_description_period_sid,
                        class_name: 'AdditionalCodeDescription'
end
