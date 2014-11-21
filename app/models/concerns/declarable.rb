module Declarable
  extend ActiveSupport::Concern
  include Formatter

  included do
    one_to_many :measures, primary_key: {}, key: {}, dataset: -> {
       Measure.join(
         Measure.with_base_regulations
                .with_actual(BaseRegulation)
                .where({measures__goods_nomenclature_sid: uptree.map(&:goods_nomenclature_sid)})
                .where{ Sequel.~(measures__measure_type_id: MeasureType::EXCLUDED_TYPES) }
                .order(Sequel.asc(:measures__measure_sid)).tap! { |query|
                 query.union(
                        Measure.with_base_regulations
                               .with_actual(BaseRegulation)
                               .where({measures__export_refund_nomenclature_sid: export_refund_uptree.map(&:export_refund_nomenclature_sid)})
                               .where{ Sequel.~(measures__measure_type_id: MeasureType::EXCLUDED_TYPES) }
                               .order(Sequel.asc(:measures__measure_sid))
                     ) if export_refund_uptree.present?
                }
        .union(
         Measure.with_modification_regulations
                .with_actual(ModificationRegulation)
                .where({measures__goods_nomenclature_sid: uptree.map(&:goods_nomenclature_sid)})
                .where{ Sequel.~(measures__measure_type_id: MeasureType::EXCLUDED_TYPES) }
                .order(Sequel.asc(:measures__measure_sid))
                .tap! {|query|
                  query.union(
                        Measure.with_modification_regulations
                               .with_actual(ModificationRegulation)
                               .where({measures__export_refund_nomenclature_sid: export_refund_uptree.map(&:export_refund_nomenclature_sid)})
                               .where{ Sequel.~(measures__measure_type_id: MeasureType::EXCLUDED_TYPES) }
                               .order(Sequel.asc(:measures__measure_sid))
                     ) if export_refund_uptree.present?
                },
          alias: :measures
        )
        .with_actual(Measure)
        .order(Sequel.asc(:measures__geographical_area_id),
               Sequel.desc(:effective_start_date)),
        t1__measure_sid: :measures__measure_sid
      ).group(:measures__measure_type_id,
              :measures__geographical_area_sid,
              :measures__measure_generating_regulation_id,
              :measures__additional_code_type_id,
              :measures__additional_code_id)
    }

    one_to_many :import_measures, key: {}, primary_key: {}, dataset: -> {
      measures_dataset.join(:measure_types, measure_types__measure_type_id: :measures__measure_type_id)
                      .filter(measure_types__trade_movement_code: MeasureType::IMPORT_MOVEMENT_CODES)
    }, class_name: 'Measure'

    one_to_many :export_measures, key: {}, primary_key: {}, dataset: -> {
      measures_dataset.join(:measure_types, measure_types__measure_type_id: :measures__measure_type_id)
                      .filter(measure_types__trade_movement_code: MeasureType::EXPORT_MOVEMENT_CODES)
    }, class_name: 'Measure'

    one_to_many :basic_duty_rate_components, primary_key: {}, key: {}, class_name: 'MeasureComponent' do
      MeasureComponent.where(measure: import_measures_dataset.where(measures__measure_type_id: MeasureType::THIRD_COUNTRY).all)
    end

    format :description_plain, with: DescriptionTrimFormatter,
                               using: :description
    format :formatted_description, with: DescriptionFormatter,
                                   using: :description
  end

  def export_refund_uptree
    @_export_refund_uptree ||= export_refund_nomenclatures.map(&:uptree).flatten
  end

  def chapter_id
    "#{goods_nomenclature_item_id.first(2)}00000000"
  end

  def consigned?
    description =~ /consigned from/i
  end

  def consigned_from
    description.scan(/consigned from ([a-zA-Z,' ]+)(?:\W|$)/i).join(", ") if consigned?
  end

  def basic_duty_rate
    basic_duty_rate_components.map(&:formatted_duty_expression).join(" ")
  end

  def meursing_code?
    measures.any?(&:meursing?)
  end
  alias :meursing_code :meursing_code?
end
