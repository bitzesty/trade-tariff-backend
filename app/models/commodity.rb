class Commodity < GoodsNomenclature
  include Tire::Model::Search

  plugin :json_serializer

  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE ?", '____000000').
              order(:goods_nomenclatures__goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  one_to_many :measures, dataset: -> {
    Measure.with_base_regulations
           .with_actual(BaseRegulation)
           .where(measures__goods_nomenclature_sid: uptree.map(&:goods_nomenclature_sid))
           .where{ ~{measures__measure_type: MeasureType::EXCLUDED_TYPES} }
           .order(:measures__measure_sid.asc)
    .union(
      Measure.with_modification_regulations
             .with_actual(ModificationRegulation)
             .where(measures__goods_nomenclature_sid: uptree.map(&:goods_nomenclature_sid))
             .where{ ~{measures__measure_type: MeasureType::EXCLUDED_TYPES} }
             .order(:measures__measure_sid.asc),
      alias: :measures
    )
    .with_actual(Measure)
    .group(:measures__measure_generating_regulation_id,
           :measures__geographical_area_sid,
           :measures__additional_code_sid)
  }

  one_to_many :import_measures, dataset: -> {
    measures_dataset.join(:measure_types, measure_type_id: :measure_type)
                    .filter{ { measure_types__trade_movement_code: MeasureType::IMPORT_MOVEMENT_CODES } }
  }, class_name: 'Measure'

  one_to_many :export_measures, dataset: -> {
    measures_dataset.join(:measure_types, measure_type_id: :measure_type)
                    .filter{ { measure_types__trade_movement_code: MeasureType::EXPORT_MOVEMENT_CODES } }
  }, class_name: 'Measure'

  one_to_one :heading, dataset: -> {
    actual(Heading).declarable
                   .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
  }

  one_to_one :chapter, dataset: -> {
    actual(Chapter).filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", chapter_id)
  }

  one_to_many :third_country_duty, dataset: -> {
    MeasureComponent.where(measure: import_measures_dataset.where(measure_type: MeasureType::THIRD_COUNTRY).all)
  }, class_name: 'MeasureComponent'

  delegate :section, to: :chapter

  # Tire configuration
  tire do
    index_name    'commodities'
    document_type 'commodity'

    mapping do
      indexes :description,        analyzer: 'snowball'
    end
  end

  dataset_module do
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
                 .where("goods_nomenclatures.goods_nomenclature_item_id <= ?", goods_nomenclature_item_id)
                 .where("goods_nomenclature_indents.number_indents < ?", goods_nomenclature_indent.number_indents)
                 .group(:goods_nomenclature_indents__number_indents),
        { t1__indents: :goods_nomenclature_indents__number_indents,
          t1__max_gono: :goods_nomenclatures__goods_nomenclature_item_id }
      )
      .group(:goods_nomenclature_indents__number_indents)
      .all
  end

  def uptree
    # @_uptree ||= [ancestors, heading, chapter, self].flatten.compact
    @_uptree ||= [heading, chapter, self].flatten.compact
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

    if sibling.present?
      heading.commodities_dataset
             .join(:goods_nomenclature_indents, goods_nomenclature_sid: :goods_nomenclature_sid)
             .where("goods_nomenclature_indents.number_indents >= ?", goods_nomenclature_indent.number_indents + 1)
             .where("goods_nomenclatures.goods_nomenclature_sid != ?", goods_nomenclature_sid)
             .where("goods_nomenclatures.producline_suffix >= ?", producline_suffix)
             .where("goods_nomenclature_indents.validity_start_date <= ? AND (goods_nomenclature_indents.validity_end_date >= ? OR goods_nomenclature_indents.validity_end_date IS NULL)", point_in_time, point_in_time, point_in_time)
             .where("goods_nomenclatures.goods_nomenclature_item_id >= ? AND goods_nomenclatures.goods_nomenclature_item_id < ?", goods_nomenclature_item_id, sibling.goods_nomenclature_item_id)
             .order(nil)
             .all
    else
      []
    end
  end

  def to_param
    code
  end

  def code
    goods_nomenclature_item_id
  end

  def uk_vat_rate
    "0.00 %"
  end

  def to_indexed_json
    {
      id: goods_nomenclature_sid,
      goods_nomenclature_item_id: goods_nomenclature_item_id,
      producline_suffix: producline_suffix,
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date,
      description: description,
      number_indents: number_indents,
      section: {
        numeral: section.numeral,
        title: section.title,
        position: section.position
      },
      chapter: {
        goods_nomenclature_sid: chapter.goods_nomenclature_sid,
        goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
        producline_suffix: chapter.producline_suffix,
        validity_start_date: chapter.validity_start_date,
        validity_end_date: chapter.validity_end_date,
        description: chapter.description.downcase
      },
      heading: {
        goods_nomenclature_sid: heading.chapter.goods_nomenclature_sid,
        goods_nomenclature_item_id: heading.chapter.goods_nomenclature_item_id,
        producline_suffix: heading.chapter.producline_suffix,
        validity_start_date: heading.chapter.validity_start_date,
        validity_end_date: heading.chapter.validity_end_date,
        description: heading.chapter.description,
        number_indents: heading.number_indents
      }
    }.to_json
  end
end
