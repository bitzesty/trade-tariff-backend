require 'time_machine'

class GoodsNomenclatureDescriptionPeriod < Sequel::Model
  plugin :time_machine

  set_primary_key :goods_nomenclature_description_period_sid

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid
  many_to_one :goods_nomenclature_description, key: [:goods_nomenclature_sid,
                                                     :goods_nomenclature_description_period_sid]
end


