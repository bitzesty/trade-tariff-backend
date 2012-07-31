require_relative 'goods_nomenclature'

class Chapter < GoodsNomenclature
  plugin :json_serializer

  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", '__00000000').
              order(:goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  many_to_many :sections, left_key: :goods_nomenclature_sid,
                          join_table: :chapters_sections

  one_to_many :headings, dataset: -> {
    actual(Heading).filter("goods_nomenclature_item_id LIKE ? AND goods_nomenclature_item_id NOT LIKE '__00______'", relevant_headings)
  }

  dataset_module do
    def by_code(code = "")
      filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", "#{code.to_s.first(2)}00000000")
    end
  end

  def short_code
    goods_nomenclature_item_id.first(2)
  end

  def to_param
    short_code
  end

  def section
    sections.first
  end

  def relevant_headings
    "#{short_code}__000000"
  end
end
