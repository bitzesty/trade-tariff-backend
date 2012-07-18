class FootnoteAssociationAdditionalCode < Sequel::Model
  set_primary_key [:footnote_id, :footnote_type_id, :additional_code_sid]

  # belongs_to :footnote_type
  # belongs_to :footnote, foreign_key: [:footnote_id, :footnote_type_id]
  # belongs_to :additional_code_type
  # # # TODO find a better way to map
  # belongs_to :ref_additional_code, foreign_key: :additional_code_sid,
  #                                  class_name: 'AdditionalCode'
end

# == Schema Information
#
# Table name: footnote_association_additional_codes
#
#  record_code             :string(255)
#  subrecord_code          :string(255)
#  record_sequence_number  :string(255)
#  additional_code_sid     :string(255)
#  footnote_type_id        :string(255)
#  footnote_id             :string(255)
#  validity_start_date     :date
#  validity_end_date       :date
#  additional_code_type_id :integer(4)
#  additional_code         :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

