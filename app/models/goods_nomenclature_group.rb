class GoodsNomenclatureGroup < ActiveRecord::Base
  self.primary_key = [:goods_nomenclature_group_type, :goods_nomenclature_group_id]
end
