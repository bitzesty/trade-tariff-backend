class GoodsNomenclatureOrigin < Sequel::Model
  set_primary_key [:goods_nomenclature_sid, :derived_goods_nomenclature_item_id,
                   :derived_productline_suffix,
                   :goods_nomenclature_item_id, :productline_suffix]

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid
end

# == Schema Information
#
# Table name: goods_nomenclature_origins
#
#  record_code                        :string(255)
#  subrecord_code                     :string(255)
#  record_sequence_number             :string(255)
#  goods_nomenclature_sid             :integer(4)
#  derived_goods_nomenclature_item_id :string(255)
#  derived_productline_suffix         :string(255)
#  goods_nomenclature_item_id         :string(255)
#  productline_suffix                 :string(255)
#  created_at                         :datetime
#  updated_at                         :datetime
#

