class GoodsNomenclatureDescriptionPeriod < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: :geographical_area_description_period_sid
  plugin :conformance_validator

  set_primary_key [:goods_nomenclature_description_period_sid]

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid
  many_to_one :goods_nomenclature_description, key: [:goods_nomenclature_sid,
                                                     :goods_nomenclature_description_period_sid]
end


