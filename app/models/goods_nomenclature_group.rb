class GoodsNomenclatureGroup < Sequel::Model
  set_primary_key  :goods_nomenclature_group_id, :goods_nomenclature_group_type

  # has_one :goods_nomenclature_group_description, foreign_key: [:goods_nomenclature_group_id,
  #                                                              :goods_nomenclature_group_type]
  # has_many :nomenclature_group_memberships, foreign_key: [:goods_nomenclature_group_id,
  #                                                         :goods_nomenclature_group_type]
  # has_many :goods_nomenclatures, through: :nomenclature_group_memberships
end

# == Schema Information
#
# Table name: goods_nomenclature_groups
#
#  record_code                      :string(255)
#  subrecord_code                   :string(255)
#  record_sequence_number           :string(255)
#  goods_nomenclature_group_type    :string(255)
#  goods_nomenclature_group_id      :string(255)
#  validity_start_date              :date
#  validity_end_date                :date
#  nomenclature_group_facility_code :integer(4)
#  created_at                       :datetime
#  updated_at                       :datetime
#

