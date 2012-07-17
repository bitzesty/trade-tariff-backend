class AdditionalCodeType < Sequel::Model
  set_primary_key :additional_code_type_id

  one_to_many :additional_codes, key: :additional_code_type_id
  one_to_one  :additional_code_type_description, key: :additional_code_type_id
  one_to_many :additional_code_descriptions, key: :additional_code_type_id
  one_to_many :additional_code_type_measure_types
  many_to_many :measure_types, join_table: :additional_code_type_measure_types
  one_to_many :additional_code_description_periods, key: :additional_code_type_id
  one_to_many :footnote_association_additional_codes, key: :additional_code_type_id
  many_to_many :footnotes, join_table: :footnote_association_additional_codes,
                       'class': :footnote

  many_to_one :meursing_table_plan

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

