class AdditionalCodeType < ActiveRecord::Base
  APPLICATION_CODES = {
    0 => "Export refund nomencalture",
    1 => "Additional Codes",
    3 => "Meursing addition codes",
    4 => "Eport refund for processed agricultural goods"
  }

  self.primary_key = :additional_code_type_id

  has_many :additional_codes
  has_many :additional_code_type_descriptions
  has_many :additional_code_descriptions
  has_many :additional_code_type_measure_types
  has_many :measures, foreign_key: :additional_code_type
end
