class AdditionalCodeDescription < ActiveRecord::Base
  belongs_to :additional_code_description_period, foreign_key: :additional_code_description_period_sid
  belongs_to :language
  belongs_to :code_type, foreign_key: :additional_code_type_id
  belongs_to :code, foreign_key: :additional_code_sid
end
