class NomenclatureGroupMembership < Sequel::Model
  set_primary_key  [:goods_nomenclature_sid, :goods_nomenclature_group_id,
                   :goods_nomenclature_group_type, :goods_nomenclature_item_id,
                   :validity_start_date]

  # belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  # belongs_to :goods_nomenclature_group, foreign_key: [:goods_nomenclature_group_id,
  #                                                     :goods_nomenclature_group_type]
end


