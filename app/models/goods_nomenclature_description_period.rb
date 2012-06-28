class GoodsNomenclatureDescriptionPeriod < ActiveRecord::Base
  self.primary_key = :goods_nomenclature_description_period_sid

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid

  has_one :goods_nomenclature_description
end
