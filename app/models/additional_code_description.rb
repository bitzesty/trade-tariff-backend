class AdditionalCodeDescription < Sequel::Model
  set_primary_key [:additional_code_description_period_sid, :additional_code_sid]

  # one_to_one :additional_code_description_period, key: [:additional_code_description_period_sid, :additional_code_sid, :additional_code_type_id]

  # many_to_one :language
  # many_to_one :additional_code_type, key: :additional_code_type_id
  # many_to_one :additional_code, key: :additional_code_sid
end

# == Schema Information
#
# Table name: additional_code_descriptions
#
#  record_code                            :string(255)
#  subrecord_code                         :string(255)
#  record_sequence_number                 :string(255)
#  additional_code_description_period_sid :string(255)
#  language_id                            :string(255)
#  additional_code_sid                    :string(255)
#  additional_code_type_id                :string(255)
#  additional_code                        :string(255)
#  description                            :text
#  created_at                             :datetime
#  updated_at                             :datetime
#

