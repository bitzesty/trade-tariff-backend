class GoodsNomenclatureDescription < ActiveRecord::Base
  belongs_to :goods_nomenclature_description_period, foreign_key: :goods_nomenclature_description_period_sid
  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  belongs_to :language
end
