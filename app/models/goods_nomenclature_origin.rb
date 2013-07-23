class GoodsNomenclatureOrigin < Sequel::Model
  plugin :oplog, primary_key: [:oid, :goods_nomenclature_sid, :derived_goods_nomenclature_item_id,
                   :derived_productline_suffix,
                   :goods_nomenclature_item_id, :productline_suffix]
  plugin :conformance_validator

  set_primary_key [:goods_nomenclature_sid, :derived_goods_nomenclature_item_id,
                   :derived_productline_suffix,
                   :goods_nomenclature_item_id, :productline_suffix]

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid
end


