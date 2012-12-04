class HiddenGoodsNomenclature < Sequel::Model
  plugin :timestamps

  set_dataset order(:goods_nomenclature_item_id.asc)

  validates do
    presence_of :goods_nomenclature_item_id
  end

  def self.codes
    all.map(&:goods_nomenclature_item_id)
  end
end
