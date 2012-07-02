class AdditionalCodeDescriptionPeriod < ActiveRecord::Base
  self.primary_key = :additional_code_description_period_sid

  has_one :description, foreign_key: :additional_code_description_period_sid,
                        class_name: 'AdditionalCodeDescription'
  belongs_to :code, foreign_key: :additional_code_sid
  belongs_to :code_type, foreign_key: :additional_code_type_id
end
