class NomenclatureGroupMembership < ActiveRecord::Base
  self.primary_key = [:goods_nomenclature_sid, :goods_nomenclature_group_type,
                      :goods_nomenclature_group_id]

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  belongs_to :goods_nomenclature_group, foreign_key: [:goods_nomenclature_group_type,
                                                      :goods_nomenclature_group_id]
end
