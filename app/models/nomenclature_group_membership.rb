class NomenclatureGroupMembership < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  belongs_to :goods_nomenclature_group, foreign_key: [:goods_nomenclature_group_type,
                                                      :goods_nomenclature_group_id]
end
