class GoodsNomenclatureGroup < Sequel::Model
  plugin :oplog, primary_key: [:goods_nomenclature_group_id,
                               :goods_nomenclature_group_type]
  plugin :conformance_validator

  set_primary_key [:goods_nomenclature_group_id, :goods_nomenclature_group_type]
end
