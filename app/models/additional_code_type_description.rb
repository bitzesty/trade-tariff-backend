class AdditionalCodeTypeDescription < ActiveRecord::Base
  belongs_to :additional_code_type, foreign_key: :additional_code_type_id
end
