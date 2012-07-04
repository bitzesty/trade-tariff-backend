class GoodsNomenclatureDescriptionPeriod < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid

  has_one :goods_nomenclature_description
end
