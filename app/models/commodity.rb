require 'commodity_mapper'

class Commodity < GoodsNomenclature
  plugin :json_serializer

  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE ?", '____000000').
              order(:goods_nomenclatures__goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  one_to_many :measures, dataset: -> {
    Measure.actual
           .relevant
           .filter('goods_nomenclature_sid IN ?', uptree.map(&:goods_nomenclature_sid))
  }

  one_to_many :import_measures, dataset: -> {
    measures_dataset.join(:measure_types, measure_type_id: :measure_type)
                    .where(trade_movement_code: MeasureType::IMPORT_MOVEMENT_CODES)
  }, class_name: 'Measure'

  one_to_many :export_measures, dataset: -> {
    measures_dataset.join(:measure_types, measure_type_id: :measure_type)
                    .where(trade_movement_code: MeasureType::EXPORT_MOVEMENT_CODES)
  }, class_name: 'Measure'

  one_to_one :heading, dataset: -> {
    Heading.actual
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
  }

  one_to_one :chapter, dataset: -> {
    Chapter.actual
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", chapter_id)
  }

  one_to_one :goods_nomenclature_indent, dataset: -> {
    GoodsNomenclatureIndent.actual
                           .filter(goods_nomenclature_sid: goods_nomenclature_sid)
  }

  delegate :section, to: :chapter

  dataset_module do
    def by_full_code(code = "")
      filter(goods_nomenclature_item_id: code.to_s.first(10), producline_suffix: code.to_s.last(2))
    end

    def by_code(code = "")
      filter(goods_nomenclature_item_id: code.to_s.first(10))
    end

    def declarable
      filter(producline_suffix: 80)
    end
  end

  def ancestors
    Commodity.select(:goods_nomenclatures.*)
      .join_table(:inner, :goods_nomenclature_indents, goods_nomenclatures__goods_nomenclature_sid: :goods_nomenclature_indents__goods_nomenclature_sid)
      .join_table(:inner,
        Commodity.actual
                 .select(:goods_nomenclature_indents__number_indents___indents,
                         Sequel.as(:max.sql_function(:goods_nomenclatures__goods_nomenclature_item_id), :max_gono))
                 .join(:goods_nomenclature_indents, goods_nomenclature_sid: :goods_nomenclature_sid)
                 .where("goods_nomenclature_indents.validity_start_date <= ? AND (goods_nomenclature_indents.validity_end_date >= ? OR goods_nomenclature_indents.validity_end_date IS NULL)", point_in_time, point_in_time, point_in_time)
                 .where("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
                 .where("goods_nomenclatures.goods_nomenclature_item_id < ?", goods_nomenclature_item_id)
                 .where("goods_nomenclature_indents.number_indents < ?", goods_nomenclature_indent.number_indents)
                 .group(:goods_nomenclature_indents__number_indents),
        { t1__indents: :goods_nomenclature_indents__number_indents,
          t1__max_gono: :goods_nomenclatures__goods_nomenclature_item_id }
      )
      .group(:goods_nomenclature_indents__number_indents)
  end

  def uptree
    ancestors.all << heading << self
  end

  def children
    sibling = heading.commodities_dataset
                     .join(:goods_nomenclature_indents, goods_nomenclature_sid: :goods_nomenclature_sid)
                     .where("goods_nomenclature_indents.number_indents = ?", goods_nomenclature_indent.number_indents)
                     .where("goods_nomenclatures.goods_nomenclature_sid != ?", goods_nomenclature_sid)
                     .where("goods_nomenclatures.producline_suffix >= ?", producline_suffix)
                     .where("goods_nomenclature_indents.validity_start_date <= ? AND (goods_nomenclature_indents.validity_end_date >= ? OR goods_nomenclature_indents.validity_end_date IS NULL)", point_in_time, point_in_time, point_in_time)
                     .order(nil)
                     .first

    heading.commodities_dataset
           .join(:goods_nomenclature_indents, goods_nomenclature_sid: :goods_nomenclature_sid)
           .where("goods_nomenclature_indents.number_indents >= ?", goods_nomenclature_indent.number_indents + 1)
           .where("goods_nomenclatures.goods_nomenclature_sid != ?", goods_nomenclature_sid)
           .where("goods_nomenclatures.producline_suffix >= ?", producline_suffix)
           .where("goods_nomenclature_indents.validity_start_date <= ? AND (goods_nomenclature_indents.validity_end_date >= ? OR goods_nomenclature_indents.validity_end_date IS NULL)", point_in_time, point_in_time, point_in_time)
           .where("goods_nomenclatures.goods_nomenclature_item_id >= ? AND goods_nomenclatures.goods_nomenclature_item_id < ?", goods_nomenclature_item_id, sibling.goods_nomenclature_item_id)
           .order(nil)
           .all
  end

  def identifier
    goods_nomenclature_item_id + producline_suffix
  end

  def code
    goods_nomenclature_item_id
  end

  # TODO calculate real rate
  def third_country_duty_rate
    "0.00 %"
  end

  def uk_vat_rate
    "0.00 %"
  end
end
