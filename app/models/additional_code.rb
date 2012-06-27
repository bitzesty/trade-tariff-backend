class AdditionalCode < ActiveRecord::Base
  self.primary_key = :additional_code_sid

  has_many :additional_code_description_periods, foreign_key: :additional_code_sid
end
