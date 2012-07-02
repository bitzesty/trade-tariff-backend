class GoodsNomenclatureGroupDescription < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :goods_nomenclature_group, foreign_key: [:goods_nomenclature_group_type, :goods_nomenclature_group_id]
  belongs_to :language
end
