class AdditionalCodeDescription < ActiveRecord::Base
  set_primary_keys :additional_code_description_period_sid, :additional_code_sid

  belongs_to :additional_code_description_period, foreign_key: :additional_code_description_period_sid
  belongs_to :language
  belongs_to :additional_code_type, foreign_key: :additional_code_type_id
  belongs_to :additional_code, foreign_key: :additional_code_sid
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

