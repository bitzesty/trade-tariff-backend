class ExportRefundNomenclature < ActiveRecord::Base
  set_primary_keys :export_refund_nomenclature_sid

  has_many :export_refund_nomenclature_description_periods, foreign_key: :export_refund_nomenclature_description_period_sid
  has_many :export_refund_nomenclature_descriptions, through: :export_refund_nomenclature_description_periods
  has_many :export_refund_nomenclature_indents, foreign_key: :export_refund_nomenclature_sid
  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
end

# == Schema Information
#
# Table name: export_refund_nomenclatures
#
#  record_code                    :string(255)
#  subrecord_code                 :string(255)
#  record_sequence_number         :string(255)
#  export_refund_nomenclature_sid :string(255)
#  goods_nomenclature_item_id     :string(255)
#  additional_code_type           :integer(4)
#  export_refund_code             :string(255)
#  productline_suffix             :string(255)
#  validity_start_date            :date
#  validity_end_date              :date
#  goods_nomenclature_sid         :string(255)
#  created_at                     :datetime
#  updated_at                     :datetime
#

