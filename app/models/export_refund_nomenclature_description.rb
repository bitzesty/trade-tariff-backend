class ExportRefundNomenclatureDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :export_refund_nomenclature, foreign_key: :export_refund_nomenclature_sid
  # belongs_to :additional_code_type
  # belongs_to :export_refund_code, foreign_key: :export_refund_code, class_name: 'AdditionalCodeType'
  belongs_to :language
end

# == Schema Information
#
# Table name: export_refund_nomenclature_descriptions
#
#  record_code                                       :string(255)
#  subrecord_code                                    :string(255)
#  record_sequence_number                            :string(255)
#  export_refund_nomenclature_description_period_sid :string(255)
#  language_id                                       :string(255)
#  export_refund_nomenclature_sid                    :string(255)
#  goods_nomenclature_item_id                        :string(255)
#  additional_code_type                              :integer(4)
#  export_refund_code                                :string(255)
#  productline_suffix                                :string(255)
#  description                                       :text
#  created_at                                        :datetime
#  updated_at                                        :datetime
#

