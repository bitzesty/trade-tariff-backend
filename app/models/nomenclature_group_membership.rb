class NomenclatureGroupMembership < ActiveRecord::Base
  set_primary_keys :goods_nomenclature_sid, :goods_nomenclature_group_id,
                   :goods_nomenclature_group_type

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  belongs_to :goods_nomenclature_group, foreign_key: [:goods_nomenclature_group_id,
                                                      :goods_nomenclature_group_type]
end

# == Schema Information
#
# Table name: nomenclature_group_memberships
#
#  record_code                   :string(255)
#  subrecord_code                :string(255)
#  record_sequence_number        :string(255)
#  goods_nomenclature_sid        :integer(4)
#  goods_nomenclature_group_type :string(255)
#  goods_nomenclature_group_id   :string(255)
#  validity_start_date           :date
#  validity_end_date             :date
#  goods_nomenclature_item_id    :string(255)
#  productline_suffix            :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime
#

