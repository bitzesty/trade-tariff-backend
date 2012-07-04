class GoodsNomenclatureDescriptionPeriod < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid

  has_one :goods_nomenclature_description
end

# == Schema Information
#
# Table name: goods_nomenclature_description_periods
#
#  record_code                               :string(255)
#  subrecord_code                            :string(255)
#  record_sequence_number                    :string(255)
#  goods_nomenclature_description_period_sid :integer(4)
#  goods_nomenclature_sid                    :integer(4)
#  validity_start_date                       :date
#  goods_nomenclature_item_id                :string(255)
#  productline_suffix                        :string(255)
#  created_at                                :datetime
#  updated_at                                :datetime
#

