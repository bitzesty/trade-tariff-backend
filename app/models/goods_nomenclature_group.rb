class GoodsNomenclatureGroup < Sequel::Model
  set_primary_key  :goods_nomenclature_group_id, :goods_nomenclature_group_type

  # TODO
  def validate
    super
    # NG1
    validates_unique([:goods_nomenclature_group_id, :goods_nomenclature_group_type])
    # NG2
    validates_start_date
  end
end


