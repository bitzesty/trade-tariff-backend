require 'time_machine'
class GoodsNomenclatureDescription < Sequel::Model
  plugin :time_machine

  set_primary_key [:goods_nomenclature_sid, :goods_nomenclature_description_period_sid]

  one_to_one :goods_nomenclature, primary_key: :goods_nomenclature_sid, key: :goods_nomenclature_sid

  def to_s
    description
  end
end


