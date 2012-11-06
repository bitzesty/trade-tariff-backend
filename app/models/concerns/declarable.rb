module Model
  module Declarable
    extend ActiveSupport::Concern

    included do
      one_to_many :measures, primary_key: {}, key: {}, dataset: -> {
         Measure.join(
           Measure.with_base_regulations
                  .with_actual(BaseRegulation)
                  .where({measures__goods_nomenclature_sid: uptree.map(&:goods_nomenclature_sid)})
                  .where{ ~{measures__measure_type: MeasureType::EXCLUDED_TYPES} }
                  .order(:measures__measure_sid.asc).tap! { |query|
                   query.union(
                          Measure.with_base_regulations
                                 .with_actual(BaseRegulation)
                                 .where({measures__export_refund_nomenclature_sid: export_refund_uptree.map(&:export_refund_nomenclature_sid)})
                                 .where{ ~{measures__measure_type: MeasureType::EXCLUDED_TYPES} }
                                 .order(:measures__measure_sid.asc)
                       ) if export_refund_uptree.present?
                  }
          .union(
           Measure.with_modification_regulations
                  .with_actual(ModificationRegulation)
                  .where({measures__goods_nomenclature_sid: uptree.map(&:goods_nomenclature_sid)})
                  .where{ ~{measures__measure_type: MeasureType::EXCLUDED_TYPES} }
                  .order(:measures__measure_sid.asc)
                  .tap! {|query|
                    query.union(
                          Measure.with_modification_regulations
                                 .with_actual(ModificationRegulation)
                                 .where({measures__export_refund_nomenclature_sid: export_refund_uptree.map(&:export_refund_nomenclature_sid)})
                                 .where{ ~{measures__measure_type: MeasureType::EXCLUDED_TYPES} }
                                 .order(:measures__measure_sid.asc)
                       ) if export_refund_uptree.present?
                  },
            alias: :measures
          )
          .with_actual(Measure)
          .order(:measures__geographical_area.asc,
                 :effective_start_date.desc),
          t1__measure_sid: :measures__measure_sid
        ).group(:measures__measure_type,
                :measures__geographical_area_sid,
                :measures__measure_generating_regulation_id,
                :measures__additional_code_type,
                :measures__additional_code)
      }

      one_to_many :import_measures, key: {}, primary_key: {}, dataset: -> {
        measures_dataset.join(:measure_types, measure_types__measure_type_id: :measures__measure_type)
                        .filter(measure_types__trade_movement_code: MeasureType::IMPORT_MOVEMENT_CODES)
      }, class_name: 'Measure'

      one_to_many :export_measures, key: {}, primary_key:{}, dataset: -> {
        measures_dataset.join(:measure_types, measure_types__measure_type_id: :measures__measure_type)
                        .filter(measure_types__trade_movement_code: MeasureType::EXPORT_MOVEMENT_CODES)
      }, class_name: 'Measure'
    end

    def export_refund_uptree
      @_export_refund_uptree ||= export_refund_nomenclatures.map(&:uptree).flatten
    end

    def chapter_id
      "#{goods_nomenclature_item_id.first(2)}00000000"
    end
  end
end
