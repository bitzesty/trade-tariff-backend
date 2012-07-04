class AdditionalCode < ActiveRecord::Base
  set_primary_keys :additional_code_sid

  has_many :additional_code_description_periods, foreign_key: :additional_code_sid
  has_many :additional_code_descriptions, through: :description_periods,
                          foreign_key: :additional_code_sid
  has_many :footnote_association_additional_codes, foreign_key: :additional_code_sid
  has_many :footnotes, through: :footnote_association_additional_codes

  has_one :measure, foreign_key: :additional_code_sid

  belongs_to :additional_code_type, foreign_key: :additional_code_type_id
end

# == Schema Information
#
# Table name: additional_codes
#
#  record_code             :string(255)     primary key
#  subrecord_code          :string(255)
#  record_sequence_number  :string(255)
#  additional_code_sid     :string(255)
#  additional_code_type_id :string(255)
#  additional_code         :string(255)
#  validity_start_date     :date
#  validity_end_date       :date
#  created_at              :datetime
#  updated_at              :datetime
#

