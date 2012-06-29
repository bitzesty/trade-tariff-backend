class AdditionalCodeDescription < ActiveRecord::Base
  # belongs_to :additional_code, foreign_key: :additional_code_sid
  belongs_to :additional_code_description_period, foreign_key: :additional_code_description_period_sid
  belongs_to :language
end
