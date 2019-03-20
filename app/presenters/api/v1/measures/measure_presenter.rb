module Api
  module V1
    module Measures
      class MeasurePresenter

        attr_reader :measure, :duty_expression

        delegate :measure_sid, :id, :origin, :effective_start_date, :effective_end_date,
                 :import, :measure_type, :measure_type_id, :legal_acts, :legal_act_ids,
                 :suspending_regulation, :suspending_regulation_id, :measure_conditions,
                 :measure_condition_ids, :national, :suspended?, :excise?, :vat?,
                 :excluded_geographical_areas, :excluded_geographical_area_ids,
                 :footnotes, :footnote_ids, :additional_code, :additional_code_id,
                 :export_refund_nomenclature, :export_refund_nomenclature_id,
                 :order_number, :order_number_id,
                 to: :measure
        alias :excise :excise?
        alias :vat :vat?

        def initialize(measure, declarable, geo_areas = nil)
          @measure = measure
          @duty_expression = Api::V1::Measures::DutyExpressionPresenter.new(measure, declarable)
          @geo_area = geo_areas&.last
        end

        def duty_expression_id
          duty_expression.id
        end

        def geographical_area
          @geo_area || measure.geographical_area
        end

        def geographical_area_id
          geographical_area.geographical_area_id
        end

        def additional_code
          measure.export_refund_nomenclature || measure.additional_code
        end

        def additional_code_id
          measure.export_refund_nomenclature_sid || measure.additional_code_sid
        end

      end
    end
  end
end