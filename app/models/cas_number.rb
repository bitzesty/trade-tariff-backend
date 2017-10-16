class CasNumber < Sequel::Model
  extend ActiveModel::Naming

  plugin :active_model
  plugin :elasticsearch
  plugin :auditable

  def chapter
    Chapter.by_code(reference).first
  end

  def heading
    Heading.by_code(reference).first
  end

  def commodities
    code6 = reference.first(6).ljust(10, "0")
    code8 = reference.first(8).ljust(10, "0")
    code10 = reference.first(10).ljust(10, "0")
    Commodity.where(goods_nomenclature_item_id: [code6, code8, code10]).all.sort_by(&:number_indents)
  end
end
