class AdditionalCodeType < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_many :additional_codes
  has_many :additional_code_type_descriptions
  has_many :additional_code_descriptions
  has_many :additional_code_type_measure_types
  has_many :measures, foreign_key: :additional_code_type
  has_many :additional_code_description_periods
  has_many :additional_code_type

  belongs_to :meursing_table_plan

  APPLICATION_CODES = {
    0 => "Export refund nomencalture",
    1 => "Additional Codes",
    3 => "Meursing addition codes",
    4 => "Eport refund for processed agricultural goods"
  }
end
