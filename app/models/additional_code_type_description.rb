class AdditionalCodeTypeDescription < ActiveRecord::Base
  self.primary_keys =  :additional_code_type_id

  belongs_to :additional_code_type, foreign_key: :additional_code_type_id
  belongs_to :language
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

