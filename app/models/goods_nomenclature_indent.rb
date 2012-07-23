class GoodsNomenclatureIndent < Sequel::Model
  set_dataset order(:validity_end_date.desc)

  plugin :time_machine

  set_primary_key :goods_nomenclature_indent_sid
  # set_primary_key  :goods_nomenclature_indent_sid

  # belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
end


