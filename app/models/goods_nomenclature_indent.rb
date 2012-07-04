class GoodsNomenclatureIndent < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
end
