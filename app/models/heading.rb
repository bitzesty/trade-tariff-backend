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

  one_to_many :measures, dataset: -> {
    actual(Measure).relevant
                   .filter('goods_nomenclature_sid IN ?', [self.goods_nomenclature_sid])
  }

  one_to_many :import_measures, dataset: -> {
    measures_dataset.join(:measure_types, measure_type_id: :measure_type)
                    .where(trade_movement_code: MeasureType::IMPORT_MOVEMENT_CODES)
  }, class_name: 'Measure'

  one_to_many :export_measures, dataset: -> {
    measures_dataset.join(:measure_types, measure_type_id: :measure_type)
                    .where(trade_movement_code: MeasureType::EXPORT_MOVEMENT_CODES)
  }, class_name: 'Measure'

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

  delegate :section, to: :chapter

  def short_code
    goods_nomenclature_item_id.first(4)
  end

  def identifier
    short_code
  end

  def declarable
    GoodsNomenclature.where("goods_nomenclature_item_id LIKE ?", "#{short_code}______").count == 1
  end
  alias :declarable? :declarable

  # TODO calculate real rate
  def third_country_duty_rate
    "0.00 %"
  end

  def uk_vat_rate
    "0.00 %"
  end
end
