module Api
  module V2
    module Measures
      class MeasurePresenter < SimpleDelegator
        attr_reader :measure, :duty_expression, :geographical_areas

        def initialize(measure, declarable, geographical_areas = [])
          super(measure)
          @measure = measure
          @duty_expression = Api::V2::Measures::DutyExpressionPresenter.new(measure, declarable)
          @geographical_areas = geographical_areas
        end

        def excise
          measure.excise?
        end

        def vat
          measure.vat?
        end

        def duty_expression_id
          duty_expression.id
        end

        def geographical_area
          measure.geographical_area
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
