class GoodsNomenclatureGroup < Sequel::Model
  set_primary_key  :goods_nomenclature_group_id, :goods_nomenclature_group_type

  # has_one :goods_nomenclature_group_description, foreign_key: [:goods_nomenclature_group_id,
  #                                                              :goods_nomenclature_group_type]
  # has_many :nomenclature_group_memberships, foreign_key: [:goods_nomenclature_group_id,
  #                                                         :goods_nomenclature_group_type]
  # has_many :goods_nomenclatures, through: :nomenclature_group_memberships
end


