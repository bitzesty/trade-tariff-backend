class GoodsNomenclatureOrigin < ActiveRecord::Base
  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
end
