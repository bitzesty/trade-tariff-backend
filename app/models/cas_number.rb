class CasNumber < Sequel::Model
  extend ActiveModel::Naming

  plugin :active_model
  plugin :elasticsearch
  plugin :auditable


  def references
    Chapter.where("goods_nomenclature_item_id LIKE ?", reference.ljust(10, "_")).all +
    Heading.where("goods_nomenclature_item_id LIKE ?", reference.ljust(10, "_")).all +
    Commodity.where("goods_nomenclature_item_id LIKE ?", reference.ljust(10, "_")).all
  end
end
