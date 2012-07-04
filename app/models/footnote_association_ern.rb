class FootnoteAssociationErn < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :export_refund_nomenclature, foreign_key: :export_refund_nomenclature_sid
  #TODO FIX ME
  # belongs_to :footnote_type, foreign_key: :footnote_type
  belongs_to :footnote
  # belongs_to :additional_code_type
  # belongs_to :export_refund_code, foreign_key: :export_refund_code, class_name: 'AdditionalCodeType'
end

# == Schema Information
#
# Table name: footnote_association_erns
#
#  record_code                    :string(255)
#  subrecord_code                 :string(255)
#  record_sequence_number         :string(255)
#  export_refund_nomenclature_sid :string(255)
#  footnote_type                  :string(255)
#  footnote_id                    :string(255)
#  validity_start_date            :date
#  validity_end_date              :date
#  goods_nomenclature_item_id     :string(255)
#  additional_code_type           :integer(4)
#  export_refund_code             :string(255)
#  productline_suffix             :string(255)
#  created_at                     :datetime
#  updated_at                     :datetime
#

