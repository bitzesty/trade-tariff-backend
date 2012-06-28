class AdditionalCode < ActiveRecord::Base
  self.primary_key = :additional_code_sid

  has_many :description_periods, foreign_key: :additional_code_sid,
                                 class_name: 'AdditionalCodeDescriptionPeriod'
end
