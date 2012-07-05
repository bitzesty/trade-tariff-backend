class GoodsNomenclatureDescription < ActiveRecord::Base
  set_primary_keys :goods_nomenclature_sid, :goods_nomenclature_description_period_sid

  has_many :goods_nomenclature_description_periods, foreign_key: [:goods_nomenclature_sid,
                                                                  :goods_nomenclature_description_period_sid]
  has_many :goods_nomenclatures, through: :goods_nomenclature_description_periods

  belongs_to :language
end

# == Schema Information
#
# Table name: goods_nomenclature_descriptions
#
#  record_code                               :string(255)
#  subrecord_code                            :string(255)
#  record_sequence_number                    :string(255)
#  goods_nomenclature_description_period_sid :integer(4)
#  language_id                               :string(255)
#  goods_nomenclature_sid                    :integer(4)
#  goods_nomenclature_item_id                :string(255)
#  productline_suffix                        :string(255)
#  description                               :text
#  created_at                                :datetime
#  updated_at                                :datetime
#

