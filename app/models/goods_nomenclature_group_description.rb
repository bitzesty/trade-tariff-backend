class GoodsNomenclatureGroupDescription < Sequel::Model
  plugin :oplog, primary_key: %i[goods_nomenclature_group_id
                                 goods_nomenclature_group_type]
  plugin :conformance_validator

  set_primary_key %i[goods_nomenclature_group_id goods_nomenclature_group_type]
end
