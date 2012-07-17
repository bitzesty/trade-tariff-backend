class AdditionalCodeTypeDescription < Sequel::Model
  set_primary_key :additional_code_type_id

  many_to_one :additional_code_type, key: :additional_code_type_id
  many_to_one :language
end

# == Schema Information
#
# Table name: additional_code_type_descriptions
#
#  record_code             :string(255)
#  subrecord_code          :string(255)
#  record_sequence_number  :string(255)
#  additional_code_type_id :string(255)
#  language_id             :string(255)
#  description             :text
#  created_at              :datetime
#  updated_at              :datetime
#

