class AdditionalCodeDescriptionPeriod < ActiveRecord::Base
  self.primary_keys =  :additional_code_description_period_sid, :additional_code_sid, :additional_code_type_id

  has_one :additional_code_description, foreign_key: :additional_code_description_period_sid
  belongs_to :additional_code, foreign_key: :additional_code_sid
  belongs_to :additional_code_type, foreign_key: :additional_code_type_id
end

# == Schema Information
#
# Table name: additional_code_description_periods
#
#  record_code                            :string(255)
#  subrecord_code                         :string(255)
#  record_sequence_number                 :string(255)
#  additional_code_description_period_sid :string(255)
#  additional_code_sid                    :string(255)
#  additional_code_type_id                :string(255)
#  additional_code                        :string(255)
#  validity_start_date                    :date
#  created_at                             :datetime
#  updated_at                             :datetime
#

