class FootnoteAssociationAdditionalCode < Sequel::Model
  set_primary_key [:footnote_id, :footnote_type_id, :additional_code_sid]

  # belongs_to :footnote_type
  # belongs_to :footnote, foreign_key: [:footnote_id, :footnote_type_id]
  # belongs_to :additional_code_type
  # # # TODO find a better way to map
  # belongs_to :ref_additional_code, foreign_key: :additional_code_sid,
  #                                  class_name: 'AdditionalCode'
end


