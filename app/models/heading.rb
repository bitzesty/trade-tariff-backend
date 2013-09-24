require 'declarable'

class Heading < GoodsNomenclature
  include Tire::Model::Search
  include Model::Declarable

  plugin :json_serializer
  plugin :oplog, primary_key: :goods_nomenclature_sid
  plugin :conformance_validator

  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", '____000000').
              filter("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE ?", '__00______').
              order(Sequel.asc(:goods_nomenclature_item_id))

  set_primary_key [:goods_nomenclature_sid]

  one_to_many :commodities, dataset: -> {
    actual_or_relevant(Commodity)
             .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
             .where(Sequel.~(goods_nomenclatures__goods_nomenclature_item_id: HiddenGoodsNomenclature.codes ))
  }

  one_to_one :chapter, dataset: -> {
    actual_or_relevant(Chapter).filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", chapter_id)
  }

  one_to_many :third_country_duty, dataset: -> {
    MeasureComponent.where(measure: import_measures_dataset.where(measures__measure_type_id: MeasureType::THIRD_COUNTRY).all)
  }, class_name: 'MeasureComponent'


  one_to_many :search_references, primary_key: :short_code

  dataset_module do
    def by_code(code = "")
      filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", "#{code.to_s.first(4)}000000")
    end

    def by_declarable_code(code = "")
      filter(goods_nomenclature_item_id: code.to_s.first(10))
    end

    def declarable
      filter(producline_suffix: 80)
    end

    def non_grouping
      filter{Sequel.~(producline_suffix: 10) }
    end
  end

  # Tire configuration
  tire do
    index_name    'headings'
    document_type 'heading'

    mapping do
      indexes :description,        analyzer: 'snowball'
    end
  end

  delegate :section, to: :chapter

  def short_code
    goods_nomenclature_item_id.first(4)
  end

  # Override to avoid lookup, this is default behaviour for headings.
  def number_indents
    0
  end

  def to_param
    short_code
  end

  def uptree
    [self, self.chapter].compact
  end

  def non_grouping?
    producline_suffix != "10"
  end

  def declarable
    non_grouping? && GoodsNomenclature.actual
                                      .where("goods_nomenclature_item_id LIKE ?", "#{short_code}______")
                                      .where("goods_nomenclature_item_id > ?", goods_nomenclature_item_id)
                                      .none?
  end
  alias :declarable? :declarable

  def serializable_hash
    heading_attributes = {
      id: goods_nomenclature_sid,
      goods_nomenclature_item_id: goods_nomenclature_item_id,
      producline_suffix: producline_suffix,
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date,
      description: description,
      number_indents: number_indents,
    }

    if chapter.present?
      heading_attributes.merge!({
        chapter: {
          goods_nomenclature_sid: chapter.goods_nomenclature_sid,
          goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
          producline_suffix: chapter.producline_suffix,
          validity_start_date: chapter.validity_start_date,
          validity_end_date: chapter.validity_end_date,
          description: chapter.description.downcase
        }
      })

      if section.present?
        heading_attributes.merge!({
          section: {
            numeral: section.numeral,
            title: section.title,
            position: section.position
          }
        })
      end
    end

    heading_attributes
  end

  def to_indexed_json
    serializable_hash.to_json
  end

  def changes(depth = 1)
    ChangeLog.new(
      operation_klass.select(
        Sequel.as('Heading', :model),
        :oid,
        :operation_date,
        :operation,
        Sequel.as(depth, :depth)
      ).where(pk_hash)
       .union(Commodity.changes_for(depth + 1, ["goods_nomenclature_item_id LIKE ? AND goods_nomenclature_item_id NOT LIKE ?", relevant_commodities, '____000000']))
       .union(Measure.changes_for(depth +1, ["goods_nomenclature_item_id LIKE ?", relevant_commodities]))
       .from_self
       .where(Sequel.~(operation_date: nil))
       .tap! { |criteria|
         # if Heading did not come from initial seed, filter by its
         # create/update date
         criteria.where{ |o| o.>=(:operation_date, operation_date) } unless operation_date.blank?
        }
       .limit(TradeTariffBackend.change_count)
       .order(Sequel.function(:isnull, :operation_date), Sequel.desc(:operation_date), Sequel.desc(:depth))
       .all
    )
  end

  def self.changes_for(depth = 0, conditions = {})
    operation_klass.select(
      Sequel.as('Heading', :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(depth, :depth)
    ).where(conditions)
     .limit(TradeTariffBackend.change_count)
     .order(Sequel.function(:isnull, :operation_date), Sequel.desc(:operation_date))
  end

  private

  def relevant_commodities
    "#{short_code}______"
  end
end
