require 'declarable'

class Commodity < GoodsNomenclature
  include Tire::Model::Search
  include Model::Declarable

  plugin :json_serializer

  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE ?", '____000000').
              order(:goods_nomenclatures__goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  one_to_one :heading, dataset: -> {
    actual_or_relevant(Heading)
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
  }

  one_to_one :chapter, dataset: -> {
    actual_or_relevant(Chapter)
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", chapter_id)
  }

  one_to_many :third_country_duty, dataset: -> {
    MeasureComponent.where(measure: import_measures_dataset.where(measures__measure_type: MeasureType::THIRD_COUNTRY).all)
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
      .eager(:goods_nomenclature_indents,
             :goods_nomenclature_descriptions)
      .join_table(:inner,
        GoodsNomenclatureIndent
                 .select(Sequel.as(:goods_nomenclatures__goods_nomenclature_sid, :gono_sid),
                         Sequel.as(:max.sql_function(:goods_nomenclatures__goods_nomenclature_item_id), :max_gono),
                         :goods_nomenclature_indents__number_indents)
                 .with_actual(GoodsNomenclature)
                 .join(:goods_nomenclatures, goods_nomenclature_indents__goods_nomenclature_sid: :goods_nomenclatures__goods_nomenclature_sid)
                 .where("goods_nomenclature_indents.goods_nomenclature_item_id LIKE ?", heading_id)
                 .where("goods_nomenclature_indents.goods_nomenclature_item_id <= ?", goods_nomenclature_item_id)
                 .where("goods_nomenclature_indents.number_indents < ?", goods_nomenclature_indent.number_indents)
                 .order(:goods_nomenclature_indents__validity_start_date.desc,
                        :goods_nomenclature_indents__goods_nomenclature_item_id.desc)
                 .group(:goods_nomenclature_indents__goods_nomenclature_sid),
        { t1__gono_sid: :goods_nomenclatures__goods_nomenclature_sid,
          t1__max_gono: :goods_nomenclatures__goods_nomenclature_item_id })
      .order(:goods_nomenclatures__goods_nomenclature_item_id.desc)
      .all
      .group_by(&:number_indents)
      .map(&:last)
      .map(&:first)
      .reverse
      .sort_by(&:number_indents)
  end

  def declarable?
    producline_suffix == '80' && children.none?
  end

  def uptree
    @_uptree ||= [ancestors, heading, chapter, self].flatten.compact
  end

  def children
    sibling = heading.commodities_dataset
                     .join(:goods_nomenclature_indents, goods_nomenclature_sid: :goods_nomenclature_sid)
                     .where("goods_nomenclature_indents.number_indents = ?", goods_nomenclature_indent.number_indents)
                     .where("goods_nomenclatures.goods_nomenclature_sid != ?", goods_nomenclature_sid)
                     .where("goods_nomenclatures.goods_nomenclature_item_id > ?", goods_nomenclature_item_id)
                     .where("goods_nomenclature_indents.validity_start_date <= ? AND (goods_nomenclature_indents.validity_end_date >= ? OR goods_nomenclature_indents.validity_end_date IS NULL)", point_in_time, point_in_time, point_in_time)
                     .order(nil)
                     .first

    if sibling.present?
      heading.commodities_dataset
             .join(:goods_nomenclature_indents, goods_nomenclature_sid: :goods_nomenclature_sid)
             .where("goods_nomenclature_indents.number_indents > ?", goods_nomenclature_indent.number_indents)
             .where("goods_nomenclatures.goods_nomenclature_sid != ?", goods_nomenclature_sid)
             .where("goods_nomenclatures.producline_suffix >= ?", producline_suffix)
             .where("goods_nomenclature_indents.validity_start_date <= ? AND (goods_nomenclature_indents.validity_end_date >= ? OR goods_nomenclature_indents.validity_end_date IS NULL)", point_in_time, point_in_time, point_in_time)
             .where("goods_nomenclatures.goods_nomenclature_item_id >= ? AND goods_nomenclatures.goods_nomenclature_item_id < ?", goods_nomenclature_item_id, sibling.goods_nomenclature_item_id)
             .order(nil)
             .all
    else
      # commodity is last in the list, check if there are any commodities
      # under it

      heading.commodities_dataset
             .join(:goods_nomenclature_indents, goods_nomenclature_sid: :goods_nomenclature_sid)
             .where("goods_nomenclature_indents.number_indents >= ?", goods_nomenclature_indent.number_indents + 1)
             .where("goods_nomenclatures.goods_nomenclature_sid != ?", goods_nomenclature_sid)
             .where("goods_nomenclature_indents.validity_start_date <= ? AND (goods_nomenclature_indents.validity_end_date >= ? OR goods_nomenclature_indents.validity_end_date IS NULL)", point_in_time, point_in_time, point_in_time)
             .where("goods_nomenclatures.goods_nomenclature_item_id >= ?", goods_nomenclature_item_id)
             .order(nil)
             .all
    end
  end

  def to_param
    code
  end

  def code
    goods_nomenclature_item_id
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
        goods_nomenclature_sid: heading.goods_nomenclature_sid,
        goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
        producline_suffix: heading.producline_suffix,
        validity_start_date: heading.validity_start_date,
        validity_end_date: heading.validity_end_date,
        description: heading.description,
        number_indents: heading.number_indents
      }
    }.to_json
  end
end
