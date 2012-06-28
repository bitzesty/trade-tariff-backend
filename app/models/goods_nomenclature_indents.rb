class GoodsNomenclatureIndents < ActiveRecord::Base
  self.primary_key = :goods_nomenclature_indent_sid

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
end
