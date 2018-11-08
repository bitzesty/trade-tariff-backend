class Commodity < GoodsNomenclature
  include Declarable

  plugin :oplog, primary_key: :goods_nomenclature_sid
  plugin :conformance_validator
  plugin :elasticsearch

  set_dataset filter("goods_nomenclatures.goods_nomenclature_item_id NOT LIKE ?", '____000000').
              order(Sequel.asc(:goods_nomenclatures__goods_nomenclature_item_id),
                    Sequel.asc(:goods_nomenclatures__producline_suffix),
                    Sequel.asc(:goods_nomenclatures__goods_nomenclature_sid))

  set_primary_key [:goods_nomenclature_sid]

  one_to_one :heading, dataset: -> {
    actual_or_relevant(Heading)
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", heading_id)
           .filter(producline_suffix: "80")
  }

  one_to_one :chapter, dataset: -> {
    actual_or_relevant(Chapter)
           .filter("goods_nomenclatures.goods_nomenclature_item_id LIKE ?", chapter_id)
  }

  one_to_many :ancestors, dataset: -> {
    actual_or_relevant(Commodity)
           .filter(goods_nomenclature_item_id: possible_ancestor_ids)
  }, class: Commodity

  def possible_ancestor_ids
    (5..10).map do |i|
      goods_nomenclature_item_id[0, i] + ('0' * (10 - i))
    end.uniq - [goods_nomenclature_item_id]
  end

  one_to_many :additional_info_measures, key: {}, primary_key: {}, dataset: -> {
    measures_dataset
        .filter(measures__measure_type_id: MeasureType::VAT_TYPES + MeasureType::SUPPLEMENTARY_TYPES + Array.wrap(MeasureType::THIRD_COUNTRY))
  }, class_name: 'Measure'

  def additional_info_measures_indexed
    search_service = ::CommodityService::AdditionalInfoMeasuresService.new(goods_nomenclature_sid, point_in_time)
    MeasurePresenter.new(
        Measure
        .distinct(:measure_generating_regulation_id, :measure_type_id, :goods_nomenclature_sid, :geographical_area_id, :geographical_area_sid, :additional_code_type_id, :additional_code_id)
        .select(Sequel.expr(:measures).*)
        .eager(
          {measure_type: :measure_type_description},
          {measure_components: [{duty_expression: :duty_expression_description},
                                {measurement_unit: :measurement_unit_description},
                                :monetary_unit,
                                :measurement_unit_qualifier]})
        .where(measure_sid: search_service.measure_sids).all, self).validate!
  end

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
      filter(producline_suffix: "80")
    end
  end

  def declarable?
    producline_suffix == '80' && children.none?
  end

  def uptree
    @_uptree ||= [ancestors, heading, chapter, self].flatten.compact
  end

  def children
    func = Proc.new {
      GoodsNomenclatureMapper.new(
        heading.commodities_dataset.
                eager(:goods_nomenclature_indents, :goods_nomenclature_descriptions).
                all
      ).all.
        detect do |item|
        item.goods_nomenclature_sid == goods_nomenclature_sid
      end.try(:children) || []
    }

    if Rails.env.test? || Rails.env.development?
      # Do not cache it in Test and Development environments.
      #
      func.call
    else
      # Cache for 3 hours
      #
      time_machine_key = Thread.current[:time_machine_now].strftime("%Y-%m-%d")
      Rails.cache.fetch("commodity_#{goods_nomenclature_sid}_#{time_machine_key}_children", expires_in: 3.hours) do
        func.call
      end
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
      Sequel.as(Sequel.cast_string("Commodity"), :model),
      :oid,
      :operation_date,
      :operation,
      Sequel.as(depth, :depth)
    ).where(conditions)
     .where(Sequel.~(operation_date: nil))
     .limit(TradeTariffBackend.change_count)
     .order(Sequel.desc(:operation_date, nulls: :last))
  end

  def changes(depth = 1)
    operation_klass.select(
      Sequel.as(Sequel.cast_string("GoodsNomenclature"), :model),
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
     .order(Sequel.desc(:operation_date, nulls: :last), Sequel.desc(:depth))
  end
end
