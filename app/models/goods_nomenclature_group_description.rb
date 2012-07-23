class GoodsNomenclatureGroupDescription < Sequel::Model
  set_primary_key  :goods_nomenclature_group_id, :goods_nomenclature_group_type

  # belongs_to :goods_nomenclature_group, foreign_key: [:goods_nomenclature_group_id,
  #                                                     :goods_nomenclature_group_type]
  # belongs_to :language
end


