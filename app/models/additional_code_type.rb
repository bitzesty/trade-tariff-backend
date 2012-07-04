class AdditionalCodeType < ActiveRecord::Base
  set_primary_keys :additional_code_type_id

  has_many :additional_codes, foreign_key: :additional_code_type_id
  has_one  :additional_code_type_description, foreign_key: :additional_code_type_id
  has_many :additional_code_descriptions, foreign_key: :additional_code_type_id
  has_many :additional_code_type_measure_types
  has_many :measure_types, through: :additional_code_type_measure_types
  has_many :additional_code_description_periods, foreign_key: :additional_code_type_id

  belongs_to :meursing_table_plan

  APPLICATION_CODES = {
    0 => "Export refund nomencalture",
    1 => "Additional Codes",
    3 => "Meursing addition codes",
    4 => "Eport refund for processed agricultural goods"
  }
end

# == Schema Information
#
# Table name: additional_code_types
#
#  record_code             :string(255)
#  subrecord_code          :string(255)
#  record_sequence_number  :string(255)
#  additional_code_type_id :string(255)
#  validity_start_date     :date
#  validity_end_date       :date
#  application_code        :string(255)
#  meursing_table_plan_id  :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

