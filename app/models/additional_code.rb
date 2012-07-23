class AdditionalCode < Sequel::Model
  set_primary_key :additional_code_sid

  one_to_one :additional_code_description, dataset: -> {
    actual(AdditionalCodeDescriptionPeriod).where(additional_code_sid: additional_code_sid)
                                           .first
                                           .additional_code_description_dataset
  }

  delegate :description, to: :additional_code_description

  def code
    "#{additional_code_type_id}#{additional_code_id}"
  end

  # one_to_many :additional_code_description_periods, left_primary_key: :additional_code_sid,  key: [:additional_code_description_period_sid, :additional_code_sid, :additional_code_type_id]
  # one_to_many :additional_code_descriptions, join_table: :additional_code_description_periods,
  #                                         key: [:additional_code_description_period_sid, :additional_code_sid]
  # one_to_many :footnote_association_additional_codes, key: :additional_code_sid
  # one_to_many :footnotes, join_table: :footnote_association_additional_codes

  # one_to_one :measure, key: :additional_code_sid

  # many_to_one :additional_code_type, key: :additional_code_type_id
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

