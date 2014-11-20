class Commodity < GoodsNomenclature
  include Declarable

  plugin :oplog, primary_key: :goods_nomenclature_sid
  plugin :conformance_validator
  plugin :elasticsearch

  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE ?", '____000000').
              order(Sequel.asc(:goods_nomenclatures__goods_nomenclature_item_id))

  set_primary_key [:goods_nomenclature_sid]

  one_to_one :heading, dataset: -> {
    actual_or_relevant(Heading)
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
           .filter(producline_suffix: 80)
  }

  one_to_one :chapter, dataset: -> {
    actual_or_relevant(Chapter)
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", chapter_id)
  }

  one_to_many :search_references, key: :referenced_id, primary_key: :code, reciprocal: :referenced, conditions: { referenced_class: 'Commodity' },
    adder: proc{ |search_reference| search_reference.update(referenced_id: code, referenced_class: 'Commodity') },
    remover: proc{ |search_reference| search_reference.update(referenced_id: nil, referenced_class: nil)},
    clearer: proc{ search_references_dataset.update(referenced_id: nil, referenced_class: nil) }

  delegate :section, to: :chapter

  dataset_module do
    def by_code(code = "")
      filter(goods_nomenclature_item_id: code.to_s.first(10))
    end

   def declarable
      filter(producline_suffix: 80)
    end
  end

  def ancestors
    Commodity.select(Sequel.expr(:goods_nomenclatures).*)
      .eager(:goods_nomenclature_indents,
             :goods_nomenclature_descriptions)
      .join_table(:inner,
        GoodsNomenclatureIndent
                 .select(:goods_nomenclature_indents__goods_nomenclature_sid,
                         :goods_nomenclature_indents__goods_nomenclature_item_id,
                         :goods_nomenclature_indents__number_indents)
                 .with_actual(GoodsNomenclature)
                 .join(:goods_nomenclatures, goods_nomenclature_indents__goods_nomenclature_sid: :goods_nomenclatures__goods_nomenclature_sid)
                 .where("goods_nomenclature_indents.goods_nomenclature_item_id LIKE ?", heading_id)
                 .where("goods_nomenclature_indents.goods_nomenclature_item_id <= ?", goods_nomenclature_item_id)
                 .order(Sequel.desc(:goods_nomenclature_indents__validity_start_date),
                        Sequel.desc(:goods_nomenclature_indents__goods_nomenclature_item_id))
                 .from_self
                 .group(:goods_nomenclature_sid)
                 .from_self
                 .where("number_indents < ?", goods_nomenclature_indent.number_indents),
        { t1__goods_nomenclature_sid: :goods_nomenclatures__goods_nomenclature_sid,
          t1__goods_nomenclature_item_id: :goods_nomenclatures__goods_nomenclature_item_id })
      .order(Sequel.desc(:goods_nomenclatures__goods_nomenclature_item_id))
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
                     .where("goods_nomenclature_indents.validity_start_date <= ? AND (goods_nomenclature_indents.validity_end_date >= ? OR goods_nomenclature_indents.validity_end_date IS NULL)", point_in_time, point_in_time)
                     .order(nil)
                     .first

    if sibling.present?
      heading.commodities_dataset
             .join(:goods_nomenclature_indents, goods_nomenclature_sid: :goods_nomenclature_sid)
             .where("goods_nomenclature_indents.number_indents > ?", goods_nomenclature_indent.number_indents)
             .where("goods_nomenclatures.goods_nomenclature_sid != ?", goods_nomenclature_sid)
             .where("goods_nomenclatures.producline_suffix >= ?", producline_suffix)
             .where("goods_nomenclature_indents.validity_start_date <= ? AND (goods_nomenclature_indents.validity_end_date >= ? OR goods_nomenclature_indents.validity_end_date IS NULL)", point_in_time, point_in_time)
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
             .where("goods_nomenclature_indents.validity_start_date <= ? AND (goods_nomenclature_indents.validity_end_date >= ? OR goods_nomenclature_indents.validity_end_date IS NULL)", point_in_time, point_in_time)
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

  def self.changes_for(depth = 0, conditions = {})
    operation_klass.select(
      Sequel.as('Commodity', :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(depth, :depth)
    ).where(conditions)
     .where(Sequel.~(operation_date: nil))
     .limit(TradeTariffBackend.change_count)
     .order(Sequel.function(:isnull, :operation_date), Sequel.desc(:operation_date))
  end

  def changes(depth = 1)
    operation_klass.select(
      Sequel.as('GoodsNomenclature', :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(depth, :depth)
    ).where(pk_hash)
     .union(
       Measure.changes_for(
         depth + 1,
         Sequel.qualify(:measures_oplog, :goods_nomenclature_item_id) => goods_nomenclature_item_id)
     )
     .from_self
     .where(Sequel.~(operation_date: nil))
     .tap! { |criteria|
       # if Commodity did not come from initial seed, filter by its
       # create/update date
       criteria.where { |o| o.>=(:operation_date, operation_date) } unless operation_date.blank?
      }
     .limit(TradeTariffBackend.change_count)
     .order(Sequel.function(:isnull, :operation_date), Sequel.desc(:operation_date), Sequel.desc(:depth))
  end
end
