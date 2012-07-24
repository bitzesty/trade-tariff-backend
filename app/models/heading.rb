class Heading < GoodsNomenclature
  plugin :json_serializer

  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", '____000000').
              filter("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE ?", '__00______').
              order(:goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  one_to_many :commodities, dataset: -> {
    actual(Commodity).filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
  }

  one_to_one :chapter, dataset: -> {
    actual(Chapter).filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", chapter_id)
  }

  dataset_module do
    def by_code(code = "")
      filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", "#{code.to_s.first(4)}000000")
    end

    def by_declarable_code(code = "")
      filter(goods_nomenclature_item_id: code.to_s.first(10))
    end

    def declarable
      filter(producline_suffix: 80)
      # join and see if it's declarable
    end
  end

  def short_code
    goods_nomenclature_item_id.first(4)
  end

  def identifier
    short_code
  end

  def declarative
    GoodsNomenclature.where("goods_nomenclature_item_id LIKE ?", "#{short_code}______").count > 1
  end
end
